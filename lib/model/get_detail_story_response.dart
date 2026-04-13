import 'package:equatable/equatable.dart';
import 'package:intermediate_project/model/story.dart';
import 'package:json_annotation/json_annotation.dart';
part 'get_detail_story_response.g.dart';

@JsonSerializable()
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
    return _$GetDetailStoryResponseFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$GetDetailStoryResponseToJson(this);
  }

  @override
  List<Object?> get props => [error, message, story];
}
