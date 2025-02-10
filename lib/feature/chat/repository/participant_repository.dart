import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class ParticipantRepository {
  Future<Either<Failure, ApiResponse<bool>>> updateLastView(int roomId);
}

class ParticipantRepositoryImpl implements ParticipantRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  ParticipantRepositoryImpl({
    required DioClient dioClient,
    AppLogger? logger,
  })  : _dioClient = dioClient,
        _logger = logger ?? AppLoggerImpl();

  @override
  Future<Either<Failure, ApiResponse<bool>>> updateLastView(int roomId) async {
    try {
      final response = await _dioClient.dioWithToken.put(
        '/participant/',
        data: FormData.fromMap({
          'room_id': roomId,
        }),
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      return right(ApiResponse(data: true));
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error updating last view', e, s);
      return left(const Failure());
    }
  }
}
