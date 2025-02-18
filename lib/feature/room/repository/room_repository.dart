import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/room/model/room.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class RoomRepository {
  Future<Either<Failure, PaginationApiResponse<Room>>> getAllAssociated({
    int page = 1,
    int limit = 10,
    int? categoryId,
  });
  Future<Either<Failure, ApiResponse<Room>>> getById(int id);
  Future<Either<Failure, bool>> create({
    required String roomName,
    required List<int> usersId,
    List<int>? categoriesId,
  });
  Future<Either<Failure, bool>> update(
    int roomId, {
    required String roomName,
    required List<int> usersId,
    List<int>? categoriesId,
  });
  Future<Either<Failure, bool>> deleteRoom(String roomId);
}

class RoomRepositoryImpl implements RoomRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  RoomRepositoryImpl({
    required DioClient dioClient,
    AppLogger? logger,
  })  : _dioClient = dioClient,
        _logger = logger ?? AppLoggerImpl();

  @override
  Future<Either<Failure, bool>> create({
    required String roomName,
    required List<int> usersId,
    List<int>? categoriesId,
  }) async {
    try {
      Map<String, dynamic> data = {
        'name': roomName,
        'users': usersId.join(','),
      };

      if (categoriesId != null || (categoriesId?.isNotEmpty ?? false)) {
        data['categories'] = categoriesId?.join(',');
      }

      final response = await _dioClient.dioWithToken.post(
        '/room/',
        data: FormData.fromMap(data),
      );

      if (response.statusCode != 201) {
        return left(const Failure());
      }

      return right(true);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error creating room', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteRoom(String roomId) async {
    // FIX: not yet implemented from backend
    throw UnimplementedError();
    // try {
    //   final response = await _dioClient.dioWithToken.delete('/room/$roomId');
    //
    //   if (response.statusCode != 200) {
    //     return left(const Failure());
    //   }
    //
    //   return right(true);
    // } on DioException catch (e) {
    //   if (e.response?.statusCode == 403) {
    //     return left(UnauthorizedFailure(message: e.messageData));
    //   }
    //
    //   return left(_dioClient.parseError(e));
    // } catch (e, s) {
    //   _logger.error('Error deleting room', e, s);
    //   return left(Failure(exception: e));
    // }
  }

  @override
  Future<Either<Failure, PaginationApiResponse<Room>>> getAllAssociated({
    int page = 1,
    int limit = 10,
    int? categoryId,
  }) async {
    _dioClient.cancelRequests();

    try {
      Map<String, dynamic> qp = {
        'page': page,
        'limit': limit,
      };

      if (categoryId != null || categoryId != 0) {
        qp['category_id'] = categoryId;
      }

      final response =
          await _dioClient.dioWithToken.get('/room', queryParameters: qp);

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final paginationResponse = PaginationApiResponse.fromJson(
        response.data,
        List.from(response.data['data']).map((e) => Room.fromJson(e)).toList(),
      );

      return right(paginationResponse);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error getting rooms', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> update(
    int roomId, {
    required String roomName,
    required List<int> usersId,
    List<int>? categoriesId,
  }) async {
    assert(usersId.length > 1, 'Room must have at least 2 users');

    try {
      Map<String, dynamic> data = {
        'name': roomName,
        'users': usersId.join(','),
      };

      if (categoriesId != null || (categoriesId?.isNotEmpty ?? false)) {
        data['categories'] = categoriesId?.join(',');
      }

      final response = await _dioClient.dioWithToken.put(
        '/room/$roomId',
        data: FormData.fromMap(data),
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      return right(true);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error updating room', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<Room>>> getById(int id) async {
    try {
      final response = await _dioClient.dioWithToken.get('/room/$id');

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      return right(
        ApiResponse.fromJson(
          response.data,
          Room.fromJson(response.data['data']),
        ),
      );
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error getting room by id', e, s);
      return left(Failure(exception: e));
    }
  }
}
