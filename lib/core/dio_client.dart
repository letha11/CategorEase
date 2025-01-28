import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/utils/constants.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  late final AuthStorage _authStorage;

  final _options = BaseOptions(
    baseUrl: Constants.baseUrl,
  );

  DioClient({
    Dio? dio,
    required AuthStorage authStorage,
  }) {
    _dio = dio ?? Dio(_options);
    _dio.interceptors.add(_acceptJsonOnlyInterceptor());
    _authStorage = authStorage;
  }

  InterceptorsWrapper _acceptJsonOnlyInterceptor() =>
      InterceptorsWrapper(onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) {
        options.headers['Accept'] = 'application/json';
        options.headers['Content-Type'] = 'application/json';
        return handler.next(options);
      });

  InterceptorsWrapper _tokenInterceptor() => InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
          final accessToken = await _authStorage.getAccessToken();
          options.headers['Authorization'] = 'Bearer $accessToken';
          return handler.next(options);
        },
      );

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
    _dio.interceptors.add(_tokenInterceptor());

    return _dio;
  }
}
