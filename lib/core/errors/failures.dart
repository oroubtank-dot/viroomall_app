// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  Failure([this.message = 'Something went wrong']);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Server error']);
}

class CacheFailure extends Failure {
  CacheFailure([super.message = 'Cache error']);
}

class AuthFailure extends Failure {
  AuthFailure([super.message = 'Authentication failed']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'No internet connection']);
}

class ValidationFailure extends Failure {
  ValidationFailure([super.message = 'Validation failed']);
}
