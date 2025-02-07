import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class AppLogger {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Object? error, StackTrace? stackTrace]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

class AppLoggerImpl implements AppLogger {
  final Logger _logger;

  AppLoggerImpl({Logger? logger})
      : _logger = logger ?? Logger(output: ConsoleOutput());

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Extends 'LogOutput' to correctly display console colors on macOS systems.
///
/// The behavior is determined by the application's run mode (Release or Debug)
/// and the operating platform (iOS or non-iOS).
///
/// For more information, see: https://github.com/simc/logger/issues/1#issuecomment-1582076726
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (kReleaseMode || !Platform.isIOS) {
      event.lines.forEach(debugPrint);
    } else {
      // event.lines.forEach(developer.log);
      event.lines.forEach(print);
    }
  }
}
