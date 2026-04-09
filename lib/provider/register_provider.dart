import 'package:flutter/foundation.dart';
import 'package:intermediate_project/service/api_service.dart';

class RegisterProvider extends ChangeNotifier{
  final ApiService apiService;

  RegisterProvider({required this.apiService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _message = '';
  String get message => _message;

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      final response = await apiService.register(name, email, password);
      _message = response.message;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _message = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

}