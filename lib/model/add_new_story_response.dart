import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_new_story_response.g.dart';

@JsonSerializable()
class AddNewStoryResponse extends Equatable {
  final bool error;
  final String message;

  const AddNewStoryResponse({required this.error, required this.message});

  factory AddNewStoryResponse.fromJson(Map<String, dynamic> json) {
    return _$AddNewStoryResponseFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$AddNewStoryResponseToJson(this);
  }

  @override
  List<Object?> get props => [error, message];
}
