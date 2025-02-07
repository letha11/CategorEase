import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/chat/model/chat.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class ChatRepository {
  Future<Either<Failure, PaginationApiResponse<Chat>>> getAllbyRoom(int roomId,
      {int page = 1, int limit = 10});
  Future<Either<Failure, ApiResponse<bool>>> delete(int chatId);
  Future<Either<Failure, ApiResponse<bool>>> update(int chatId, String content);
}

class ChatRepositoryImpl implements ChatRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  ChatRepositoryImpl({required DioClient dioClient, AppLogger? logger})
      : _dioClient = dioClient,
        _logger = logger ?? AppLoggerImpl();

  @override
  Future<Either<Failure, PaginationApiResponse<Chat>>> getAllbyRoom(
    int roomId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response =
          await _dioClient.dioWithToken.get('/chat/$roomId', queryParameters: {
        'page': page,
        'limit': limit,
      });

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final paginationResponse = PaginationApiResponse.fromJson(
        response.data,
        List.from(response.data['data']).map((e) => Chat.fromJson(e)).toList(),
      );

      return right(paginationResponse);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error occured while getting all chat by room', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> delete(int chatId) async {
    try {
      final response = await _dioClient.dioWithToken.delete('/chat/$chatId');

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final paginationResponse = ApiResponse.fromJson(
        response.data,
        true,
      );

      return right(paginationResponse);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error occured while deleting chat', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<bool>>> update(
      int chatId, String content) async {
    try {
      final response = await _dioClient.dioWithToken.put(
        '/chat/$chatId',
        data: FormData.fromMap({
          'content': content,
        }),
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final paginationResponse = ApiResponse.fromJson(
        response.data,
        true,
      );

      return right(paginationResponse);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error occured while updating chat', e, s);
      return left(Failure(exception: e));
    }
  }
}
