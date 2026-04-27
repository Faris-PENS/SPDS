import 'package:easy_localization/easy_localization.dart';

class LocationDisabledException implements Exception {
  @override
  String toString() {
    return 'enableYourLocationService'.tr();
  }
}

class LocationAccessDeniedException implements Exception {
  @override
  String toString() {
    return 'locationAccessDenied'.tr();
  }
}

class StorageAccessDeniedException implements Exception {}

class FileNotFoundException implements Exception {
  @override
  String toString() {
    return 'File not found';
  }
}

class AppCustomException implements Exception {
  String message;
  int? code;
  StackTrace? stackTrace;

  AppCustomException(
    this.message, {
    this.code,
    this.stackTrace,
  });

  @override
  String toString() {
    return message;
  }
}

class CancellationException implements Exception {
  @override
  String toString() {
    return 'Request cancelled';
  }
}

class SessionInvalidException implements Exception {
  String? message;

  SessionInvalidException([this.message]);

  @override
  String toString() {
    return message ?? "Session expired, please log in again.";
  }
}
