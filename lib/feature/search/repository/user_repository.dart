import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/home/model/user.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  Future<Either<Failure, PaginationApiResponse<User>>> getAllUser({
    int page = 1,
    int limit = 10,
    String? username,
  });
}

class UserRepositoryImpl implements UserRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  UserRepositoryImpl({required DioClient dioClient, required AppLogger logger})
      : _dioClient = dioClient,
        _logger = logger;

  @override
  Future<Either<Failure, PaginationApiResponse<User>>> getAllUser({
    int page = 1,
    int limit = 10,
    String? username,
  }) async {
    _dioClient.cancelRequests();

    try {
      Map<String, dynamic> qp = {
        'page': page,
        'limit': limit,
      };

      if (username != null) {
        qp['username'] = username;
      }

      final response = await _dioClient.dioWithToken.get(
        '/user/',
        queryParameters: qp,
        cancelToken: _dioClient.cancelToken,
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final paginationResponse = PaginationApiResponse.fromJson(
        response.data,
        List.from(response.data['data']).map((e) => User.fromJson(e)).toList(),
      );

      return right(paginationResponse);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error occured while getting all user', e, s);
      return left(Failure(exception: e));
    }
  }
}
