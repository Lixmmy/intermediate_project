import 'package:intermediate_project/model/login_result.dart';

sealed class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String message;
  final LoginResult loginResult;
  LoginSuccessState(this.message, this.loginResult);
}

class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState(this.errorMessage);
}
