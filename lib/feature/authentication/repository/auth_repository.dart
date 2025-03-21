import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:categorease/utils/extension.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, bool>> login(String username, String password);
  Future<Either<Failure, bool>> refreshToken(String refreshToken);
  Future<Either<Failure, ApiResponse<User>>> getAuthenticatedUser();
  Future<Either<Failure, bool>> register(
      String username, String password, String confirmPassword);
  Future<Either<Failure, bool>> logout();
}

class AuthRepositoryImpl extends AuthRepository {
  final AuthStorage _authStorage;
  final DioClient _dioClient;
  final AppLogger _logger;

  AuthRepositoryImpl(
      {required DioClient dioClient,
      AuthStorage? authStorage,
      AppLogger? logger})
      : _dioClient = dioClient,
        _authStorage = authStorage ?? AuthStorageImpl(),
        _logger = logger ?? AppLoggerImpl();

  @override
  Future<Either<Failure, bool>> login(String username, String password) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _authStorage.setAccessToken(data['access_token']);
        await _authStorage.setRefreshToken(data['refresh_token']);

        return right(true);
      }

      return left(const AuthFailure());
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return left(
            const Failure(message: 'Wrong username or password, try again'));
      }

      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Login error', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> register(
      String username, String password, String confirmPassword) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/register',
        data: FormData.fromMap({
          'username': username,
          'password': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 201) {
        final data = response.data['data'];
        await _authStorage.setAccessToken(data['access_token']);
        await _authStorage.setRefreshToken(data['refresh_token']);

        _logger.info('Register success');
        return right(true);
      }

      _logger.warning('Register failed', response);
      return left(const AuthFailure());
    } on DioException catch (e, s) {
      if (e.response?.statusCode == 409) {
        _logger.warning('Register failed', e.response);
        return left(
            AuthFailure(message: e.messageData ?? 'User already exists'));
      } else if (e.response?.statusCode == 422) {
        _logger.warning('Register failed', e.response);
        return left(AuthFailure(
            message:
                e.messageData ?? 'Password and confirm password do not match'));
      }

      _logger.error('Register error', e, s);
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Register error', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _authStorage.clearTokens();
      _logger.info('Logout success');
      return right(false);
    } catch (e, s) {
      _logger.error('Logout error', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> refreshToken(String refreshToken) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/refresh-token',
        data: FormData.fromMap({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      _authStorage.clearTokens();
      final data = response.data['data'];
      await _authStorage.setAccessToken(data['access_token']);
      await _authStorage.setRefreshToken(data['refresh_token']);

      return right(true);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Login error', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<User>>> getAuthenticatedUser() async {
    try {
      final response = await _dioClient.dioWithToken.get(
        '/auth/user',
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final result = ApiResponse.fromJson(
        response.data,
        User.fromJson(response.data['data']),
      );

      _authStorage.setAuthenticatedUser(result.data!);

      return right(result);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Login error', e, s);
      return left(Failure(exception: e));
    }
  }
}
