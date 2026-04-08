import 'package:equatable/equatable.dart';

class AddNewStoryResponse extends Equatable{
  final String error;
  final String message;

  const AddNewStoryResponse({required this.error, required this.message});

  factory AddNewStoryResponse.fromJson(Map<String, dynamic> json) {
    return AddNewStoryResponse(
      error: json['error'] as String,
      message: json['message'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }

  @override
  List<Object?> get props => [error, message];
}