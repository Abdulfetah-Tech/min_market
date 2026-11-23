// Production-grade API client with Dio
// Features: interceptors, retry policy, connectivity handling, logging

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'package:min_market/core/config/environment.dart';
import 'package:min_market/core/error/failures.dart';

class ApiClient {
  late final Dio _dio;
  final Talker _talker;
  final Connectivity _connectivity;
  bool _isRefreshing = false;

  ApiClient({
    required Talker talker,
    Connectivity? connectivity,
  })  : _talker = talker,
        _connectivity = connectivity ?? Connectivity() {
    _initializeDio();
    _setupConnectivityListener();
  }

  void _initializeDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        receiveTimeout: Duration(milliseconds: int.parse(AppConfig.apiTimeout)),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.addAll([
      // Retry interceptor with exponential backoff
      RetryInterceptor(
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryEvaluator: (e) => _shouldRetry(e),
      ),
      // Logging interceptor
      if (AppConfig.enableLogging)
        TalkerDioLogger(
          talker: _talker,
          settings: TalkerDioLoggerSettings(
            printRequestHeaders: true,
            printResponseHeaders: true,
            printRequestData: true,
            printResponseData: true,
          ),
        ),
      // Auth interceptor (placeholder for future token handling)
      _AuthInterceptor(),
      // Error handling interceptor
      _ErrorInterceptor(talker: _talker),
    ]);
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.none)) {
        _talker.warning('Network connectivity lost');
      } else {
        _talker.info('Network connectivity restored: $result');
      }
    });
  }

  bool _shouldRetry(DioException e) {
    // Retry on network errors, timeouts, and 5xx server errors
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError ||
        (e.response?.statusCode != null && e.response!.statusCode! >= 500);
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) parser,
  }) async {
    if (!await _hasConnection()) {
      return Left<Failure, T>(const NoConnectionFailure());
    }

    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return Right<Failure, T>(parser(response.data));
    } on DioException catch (e, stackTrace) {
      return Left<Failure, T>(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left<Failure, T>(UnknownFailure(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) parser,
  }) async {
    if (!await _hasConnection()) {
      return Left<Failure, T>(const NoConnectionFailure());
    }

    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right<Failure, T>(parser(response.data));
    } on DioException catch (e, stackTrace) {
      return Left<Failure, T>(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left<Failure, T>(UnknownFailure(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    required T Function(dynamic) parser,
  }) async {
    if (!await _hasConnection()) {
      return Left<Failure, T>(const NoConnectionFailure());
    }

    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return Right<Failure, T>(parser(response.data));
    } on DioException catch (e, stackTrace) {
      return Left<Failure, T>(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left<Failure, T>(UnknownFailure(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<Result<void>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    if (!await _hasConnection()) {
      return Left<Failure, void>(const NoConnectionFailure());
    }

    try {
      await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return const Right<Failure, void>(null);
    } on DioException catch (e, stackTrace) {
      return Left<Failure, void>(_mapDioException(e, stackTrace));
    } catch (e, stackTrace) {
      return Left<Failure, void>(UnknownFailure(
        message: 'Unexpected error: $e',
        originalError: e,
        stackTrace: stackTrace,
      ));
    }
  }

  Future<bool> _hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  Failure _mapDioException(DioException e, StackTrace stackTrace) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return TimeoutFailure(
          message: 'Connection timeout: ${e.message}',
          originalError: e,
          stackTrace: stackTrace,
        );
      case DioExceptionType.connectionError:
        return NetworkFailure(
          message: 'Network error: ${e.message}',
          originalError: e,
          stackTrace: stackTrace,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        final message = _extractErrorMessage(e.response?.data) ?? 'Server error: $statusCode';

        switch (statusCode) {
          case 401:
            return UnauthorizedFailure(
              message: message,
              originalError: e,
              stackTrace: stackTrace,
            );
          case 403:
            return ForbiddenFailure(
              message: message,
              originalError: e,
              stackTrace: stackTrace,
            );
          case 404:
            return NotFoundFailure(
              message: message,
              originalError: e,
              stackTrace: stackTrace,
            );
          default:
            return ServerFailure(
              message: message,
              statusCode: statusCode,
              originalError: e,
              stackTrace: stackTrace,
            );
        }
      case DioExceptionType.cancel:
        return const UnknownFailure(
          message: 'Request cancelled',
        );
      case DioExceptionType.unknown:
        if (e.error is SocketException) {
          return NetworkFailure(
            message: 'Network unavailable',
            originalError: e,
            stackTrace: stackTrace,
          );
        }
        return UnknownFailure(
          message: 'Unknown error: ${e.message}',
          originalError: e,
          stackTrace: stackTrace,
        );
      default:
        return UnknownFailure(
          message: 'Request failed: ${e.message}',
          originalError: e,
          stackTrace: stackTrace,
        );
    }
  }

  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }
    return null;
  }

  void dispose() {
    _dio.close();
  }
}

// Retry interceptor with exponential backoff
class RetryInterceptor extends Interceptor {
  final int retries;
  final List<Duration> retryDelays;
  final bool Function(DioException) retryEvaluator;

  RetryInterceptor({
    required this.retries,
    required this.retryDelays,
    required this.retryEvaluator,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retryCount = options.extra['retryCount'] as int? ?? 0;

    if (retryCount < retries && retryEvaluator(err)) {
      final delay = retryDelays[retryCount.clamp(0, retryDelays.length - 1)];
      await Future.delayed(delay);

      options.extra['retryCount'] = retryCount + 1;
      try {
        final response = await Dio().fetch(options);
        handler.resolve(response);
        return;
      } catch (e) {
        // Continue to next retry or fail
      }
    }

    handler.next(err);
  }
}

// Auth interceptor for token handling
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    // final token = await _secureStorage.read(key: 'auth_token');
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle 401 - token refresh logic
    // if (err.response?.statusCode == 401 && !_isRefreshing) {
    //   _isRefreshing = true;
    //   try {
    //     await _refreshToken();
    //     // Retry original request
    //   } finally {
    //     _isRefreshing = false;
    //   }
    // }
    handler.next(err);
  }
}

// Error interceptor for consistent error handling
class _ErrorInterceptor extends Interceptor {
  final Talker _talker;

  _ErrorInterceptor({required Talker talker}) : _talker = talker;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _talker.error(
      'API Error: ${err.requestOptions.method} ${err.requestOptions.path}',
      err,
      err.stackTrace,
    );
    handler.next(err);
  }
}