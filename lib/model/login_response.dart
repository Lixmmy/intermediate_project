import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/login_result.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
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
    return _$LoginResponseFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$LoginResponseToJson(this);
  }

  @override
  List<Object?> get props => [error, message, loginResult];
}
