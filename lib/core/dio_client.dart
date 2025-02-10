import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/core/service_locator.dart';
import 'package:categorease/feature/authentication/repository/auth_repository.dart';
import 'package:categorease/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  late final Dio _dio;
  late final AuthStorage _authStorage;
  late final AppLogger _logger;
  late final CancelToken _cancelToken;

  final _options = BaseOptions(
    baseUrl: Constants.getDevBaseUrl(),
  );

  DioClient({
    Dio? dio,
    required AuthStorage authStorage,
    AppLogger? logger,
  }) {
    _dio = dio ?? Dio(_options);
    _dio.interceptors.add(_acceptJsonOnlyInterceptor());
    _dio.interceptors.add(PrettyDioLogger(
      compact: true,
      responseBody: true,
      requestBody: true,
    ));
    _cancelToken = CancelToken();
    _logger = logger ?? AppLoggerImpl();
    _authStorage = authStorage;
  }

  void cancelRequests([CancelToken? token]) {
    if (token != null) {
      token.cancel();
      return;
    }

    _cancelToken.cancel();
  }

  InterceptorsWrapper _acceptJsonOnlyInterceptor() =>
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers['Accept'] = 'application/json';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      });

  InterceptorsWrapper _refreshTokenInterceptor() => InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          final refreshToken = await _authStorage.getRefreshToken();
          options.headers['Authorization'] = 'Bearer $refreshToken';
          return handler.next(options);
        },
      );

  Dio get dio => _dio;

  Dio get dioWithRefreshToken {
    _dio.interceptors.add(_refreshTokenInterceptor());

    return _dio;
  }

  Dio get dioWithToken {
    _dio.interceptors.add(TokenInterceptor(
      authStorage: _authStorage,
      authRepository: sl(),
      logger: _logger,
    ));

    return _dio;
  }

  Failure parseError(DioException exception) {
    final type = exception.type;

    _logger.warning('Dio error', exception);

    if (exception.response?.statusCode == 403 ||
        exception.response?.statusCode == 401) {
      return const UnauthorizedFailure();
    } else if (exception.response?.statusCode == 422) {
      return const UnprocessableContent();
    }

    switch (type) {
      case DioExceptionType.connectionTimeout:
        return const TimeoutFailure();
      case DioExceptionType.sendTimeout:
        return const TimeoutFailure();
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();
      case DioExceptionType.badResponse:
        return const Failure(message: 'Bad response');
      case DioExceptionType.cancel:
        return const Failure(message: 'Request cancelled');
      default:
        return const Failure(message: 'Server error, please try again later');
    }
  }
}

class TokenInterceptor extends Interceptor {
  final AuthStorage _authStorage;
  final AuthRepository _authRepository;
  final AppLogger _logger;
  final int _maxRetry = 3;
  int _retryCount = 0;

  TokenInterceptor({
    required AuthStorage authStorage,
    required AuthRepository authRepository,
    required AppLogger logger,
  })  : _authStorage = authStorage,
        _authRepository = authRepository,
        _logger = logger;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await _authStorage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && _retryCount <= _maxRetry) {
      String? refreshToken = await _authStorage.getRefreshToken();

      if (refreshToken == null) {
        return handler.reject(err);
      }
      _logger.info('Performing renewing token');
      _retryCount++;

      await _authRepository.refreshToken(refreshToken);

      try {
        final response = await _getRetryRequest(err);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      } catch (e) {
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }

  Future<Response> _getRetryRequest(DioException err) async {
    if (err.response == null) {
      throw err;
    }

    String? freshToken = await _authStorage.getAccessToken();
    if (freshToken == null) {
      throw err;
    }

    final requestOptions = err.response!.requestOptions;
    requestOptions.headers['Authorization'] = 'Bearer $freshToken';

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    final dioRefresh = Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dioRefresh.interceptors.add(this);

    dynamic data;
    if (requestOptions.data != null && requestOptions.data is FormData) {
      data = (requestOptions.data as FormData).clone();
    } else {
      data = requestOptions.data;
    }

    final response = await dioRefresh.request(
      requestOptions.path,
      data: data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );

    return response;
  }
}
