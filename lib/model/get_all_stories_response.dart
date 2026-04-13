import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/story.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_stories_response.g.dart';

@JsonSerializable()
class GetAllStoriesResponse extends Equatable {
  final bool error;
  final String message;
  @JsonKey(name: 'listStory')
  final List<Story> stories;

  const GetAllStoriesResponse({
    required this.error,
    required this.message,
    required this.stories,
  });

  factory GetAllStoriesResponse.fromJson(Map<String, dynamic> json) {
    return _$GetAllStoriesResponseFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$GetAllStoriesResponseToJson(this);
  }

  @override
  List<Object?> get props => [error, message];
}
