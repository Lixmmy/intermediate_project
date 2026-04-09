import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intermediate_project/provider/login/login_state.dart';
import 'package:intermediate_project/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;
  LoginProvider(this.apiService);

  LoginState _state = LoginInitialState();

  LoginState get state => _state;


  Future<void> sendLoginRequest(String email, String password) async{
    try {
      _state = LoginLoadingState(); 
      notifyListeners();

      final response = await apiService.login(email, password);
      if (!response.error) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.loginResult.token);
        await prefs.setString('loginResult', jsonEncode(response.loginResult.toJson()));
        
        _state = LoginSuccessState(
          response.message,
          response.loginResult,
        );
      } else {
        _state = LoginErrorState(response.message);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      _state = LoginErrorState(errorMessage);
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('loginResult');
    _state = LoginInitialState();
    notifyListeners();
  }
}
