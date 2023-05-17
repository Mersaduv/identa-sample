import 'package:flutter/material.dart';
import 'package:identa_app/screens/chat.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:identa_app/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'My App',
        home: ChatScreen(),
      ),
    );
  }
}

// In this code, first an instance of AuthService is created using Provider.of<AuthService>(context). Then, by checking the existence of the login token in authService.accessToken, if the user was logged in, a text "Logged in!" is displayed. Otherwise, a login button with the text "Login" is displayed, which by pressing it, the user is directed to the login page.
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: authService.accessToken != null
            ? Text('Logged in!')
            : TextButton(
                onPressed: () async {
                  await authService.signInWithNoCodeExchange();
                },
                child: Text('Login'),
              ),
      ),
    );
  }
}
