import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sgp_movil/features/login/presentation/providers/login_provider.dart';

final goRouterNotifierProvider = ChangeNotifierProvider((ref) 
{
  final loginNotifier = ref.read(loginProvider.notifier);
  return GoRouterNotifier(loginNotifier);
});

class GoRouterNotifier extends ChangeNotifier 
{
  final LoginNotifier _loginNotifier;

  LoginStatus _loginStatus = LoginStatus.checking;

  GoRouterNotifier(this._loginNotifier) 
  {
    _loginNotifier.addListener((state) 
    {
      loginStatus = state.loginStatus;
    });
  }

  LoginStatus get loginStatus => _loginStatus;

  set loginStatus(LoginStatus value) 
  {
    if (_loginStatus != value) {
      _loginStatus = value;
      notifyListeners();
    }
  }

}
