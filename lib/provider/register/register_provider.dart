import 'package:flutter/foundation.dart';
import 'package:intermediate_project/provider/register/register_state.dart';
import 'package:intermediate_project/service/api_service.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService;

  RegisterProvider({required this.apiService});

  RegisterState _state = RegisterInitialState();
  RegisterState get state => _state;

  Future<void> register(String name, String email, String password) async {
    try {
      _state = RegisterLoadingState();
      notifyListeners();
      final response = await apiService.register(name, email, password);
      if (!response.error) {
        _state = RegisterSuccessState(response.message);
      } else {
        _state = RegisterErrorState(response.message);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }
      _state = RegisterErrorState(errorMessage);
    } finally {
      notifyListeners();
    }
  }

  Future<void> resetState() async {
    if (_state is RegisterSuccessState) {
      _state = RegisterInitialState();
    }
  }
}
