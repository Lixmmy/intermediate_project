import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/login_result.dart';

class LoginResponse extends Equatable {
  final bool error;
  final String message;
  final LoginResult loginResult;

  const LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      loginResult: LoginResult.fromJson(
        json['loginResult'] as Map<String, dynamic>,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'loginResult': loginResult.toJson(),
    };
  }

  @override
  List<Object?> get props => [error, message, loginResult];
}
