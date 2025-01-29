import 'package:categorease/core/app_logger.dart';
import 'package:categorease/core/auth_storage.dart';
import 'package:categorease/core/failures.dart';
import 'package:categorease/utils/constants.dart';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  late final AuthStorage _authStorage;
  late final AppLogger _logger;
  late final CancelToken _cancelToken;

  final _options = BaseOptions(
    baseUrl: Constants.baseUrl,
  );

  DioClient({
    Dio? dio,
    required AuthStorage authStorage,
    AppLogger? logger,
  }) {
    _dio = dio ?? Dio(_options);
    _dio.interceptors.add(_acceptJsonOnlyInterceptor());
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

  Failure parseError(DioException exception) {
    final type = exception.type;

    _logger.warning('Dio error', exception);

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
