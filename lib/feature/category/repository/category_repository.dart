import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/dio_client.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/feature/category/model/category.dart';
import 'package:categorease/utils/api_response.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

abstract class CategoryRepository {
  Future<Either<Failure, ApiResponse<List<Category>>>> getAllAssociated(
      {int? categoryId});
  Future<Either<Failure, bool>> create({
    required String name,
    required List<int> roomIds,
    String hexColor,
  });
  Future<Either<Failure, bool>> update({
    required String name,
    required List<int> roomsId,
    required String hexColor,
  });
}

class CategoryRepositoryImpl implements CategoryRepository {
  final DioClient _dioClient;
  final AppLogger _logger;

  CategoryRepositoryImpl({
    required DioClient dioClient,
    AppLogger? logger,
  })  : _dioClient = dioClient,
        _logger = logger ?? AppLoggerImpl();

  @override
  Future<Either<Failure, ApiResponse<List<Category>>>> getAllAssociated({
    int? categoryId,
  }) async {
    try {
      Map<String, dynamic> qp = {};

      if (categoryId != null) {
        qp['category_id'] = categoryId;
      }

      final response =
          await _dioClient.dioWithToken.get('/category', queryParameters: qp);

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      final data = ApiResponse<List<Category>>.fromJson(
        response.data,
        List.from(
          response.data['data'].map((e) => Category.fromJson(e)),
        ),
      );

      return right(data);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error getting categories', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> create({
    required String name,
    required List<int> roomIds,
    String? hexColor,
  }) async {
    try {
      Map<String, dynamic> data = {
        'name': name,
        'rooms': roomIds.join(','),
      };

      if (hexColor != null) {
        data['color'] = hexColor;
      }

      final response = await _dioClient.dioWithToken.post(
        '/category/',
        data: FormData.fromMap(data),
      );

      if (response.statusCode != 201) {
        return left(const Failure());
      }

      return right(true);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error creating category', e, s);
      return left(Failure(exception: e));
    }
  }

  @override
  Future<Either<Failure, bool>> update({
    required String name,
    required List<int> roomsId,
    required String hexColor,
  }) async {
    try {
      final response = await _dioClient.dioWithToken.put(
        '/category',
        data: FormData.fromMap({
          'name': name,
          'rooms': roomsId,
          'color': hexColor,
        }),
      );

      if (response.statusCode != 200) {
        return left(const Failure());
      }

      return right(true);
    } on DioException catch (e) {
      return left(_dioClient.parseError(e));
    } catch (e, s) {
      _logger.error('Error updating category', e, s);
      return left(Failure(exception: e));
    }
  }
}
