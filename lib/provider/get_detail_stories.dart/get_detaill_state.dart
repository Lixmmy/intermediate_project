import 'package:intermediate_project/model/story.dart';

sealed class GetDetaillState {}

class GetDetaillInitialState extends GetDetaillState {}

class GetDetaillLoadingState extends GetDetaillState {}

class GetDetaillSuccessState extends GetDetaillState {
  final String message;
  final Story story;
  GetDetaillSuccessState(this.message, this.story);
}

class GetDetaillErrorState extends GetDetaillState {
  final String errorMessage;
  GetDetaillErrorState(this.errorMessage);
}
