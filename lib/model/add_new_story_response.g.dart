// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_new_story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddNewStoryResponse _$AddNewStoryResponseFromJson(Map<String, dynamic> json) =>
    AddNewStoryResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
    );

Map<String, dynamic> _$AddNewStoryResponseToJson(
  AddNewStoryResponse instance,
) => <String, dynamic>{'error': instance.error, 'message': instance.message};
