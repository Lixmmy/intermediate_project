import 'package:equatable/equatable.dart';

class LoginResult extends Equatable {
  final String userId;
  final String name;
  final String token;

  const LoginResult({required this.userId, required this.name, required this.token});

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      userId: json['userId'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'userId': userId, 'name': name, 'token': token};
  }

  @override
  List<Object?> get props => [userId, name, token];
}
