sealed class AddStoryState {}

class AddStoryInitialState extends AddStoryState {}

class AddStoryLoadingState extends AddStoryState {}

class AddStorySuccessState extends AddStoryState {
  final String message;
  AddStorySuccessState(this.message);
}

class AddStoryErrorState extends AddStoryState {
  final String errorMessage;
  AddStoryErrorState(this.errorMessage);
}
