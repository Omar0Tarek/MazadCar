import 'package:flutter/material.dart';

import 'LoginPage.dart';
import 'RegisterPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginPage(
            onClickedSignUp: toggle,
          )
        : RegisterPage(
            onClickedSignIn: toggle,
          );
  }

  void toggle() => setState(() => isLogin = !isLogin);
}
