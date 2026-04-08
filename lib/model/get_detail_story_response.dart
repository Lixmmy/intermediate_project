import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/story.dart';

class GetDetailStoryResponse extends Equatable {
  final bool error;
  final String message;
  final Story story;

  const GetDetailStoryResponse({
    required this.error,
    required this.message,
    required this.story,
  });

  factory GetDetailStoryResponse.fromJson(Map<String, dynamic> json) {
    return GetDetailStoryResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: Story.fromJson(json['story'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message, 'story': story.toJson()};
  }

  @override
  List<Object?> get props => [error, message, story];
}
