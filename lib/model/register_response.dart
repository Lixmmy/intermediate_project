import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final bool error;
  final String message;

  const RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }

  @override
  List<Object?> get props => [error, message];
}
