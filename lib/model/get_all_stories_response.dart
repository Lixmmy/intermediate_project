import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/story.dart';

class GetAllStoriesResponse extends Equatable {
  final bool error;
  final String message;
  final List<Story> stories;

  const GetAllStoriesResponse({
    required this.error,
    required this.message,
    required this.stories,
  });

  factory GetAllStoriesResponse.fromJson(Map<String, dynamic> json) {
    return GetAllStoriesResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      stories: (json['listStory'] as List)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {'error': error, 'message': message};
  }

  @override
  List<Object?> get props => [error, message];
}
