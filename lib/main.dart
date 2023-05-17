import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:platform/platform.dart';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        home: LoginPage(),
      ),
    );
  }
}

// In this code, first an instance of AuthService is created using Provider.of<AuthService>(context). Then, by checking the existence of the login token in authService.accessToken, if the user was logged in, a text "Logged in!" is displayed. Otherwise, a login button with the text "Login" is displayed, which by pressing it, the user is directed to the login page.

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Visibility(
                  visible: authService.isBusy,
                  child: const LinearProgressIndicator(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Sign in with no code exchange'),
                  onPressed: () => authService.signInWithNoCodeExchange(),
                ),
                ElevatedButton(
                  child: const Text(
                      'Sign in with no code exchange and generated nonce'),
                  onPressed: () =>
                      authService.signInWithNoCodeExchangeAndGeneratedNonce(),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('Sign in with auto code exchange'),
                  onPressed: () => authService.signInWithAutoCodeExchange(),
                ),
                if (Platform.isIOS || Platform.isMacOS)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: const Text(
                        'Sign in with auto code exchange using ephemeral '
                        'session',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => authService.signInWithAutoCodeExchange(
                          preferEphemeralSession: true),
                    ),
                  ),
                ElevatedButton(
                  child: const Text('Refresh token'),
                  onPressed: authService.refreshToken != null
                      ? authService.refresh
                      : null,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text('End session'),
                  onPressed: authService.idToken != null
                      ? () async {
                          await authService.endSession();
                        }
                      : null,
                ),
                const SizedBox(height: 8),
                const Text('authorization code'),
                TextField(
                  controller: authService.authorizationCodeTextController,
                ),
                const Text('access token'),
                TextField(
                  controller: authService.accessTokenTextController,
                ),
                const Text('access token expiration'),
                TextField(
                  controller: authService.accessTokenExpirationTextController,
                ),
                const Text('id token'),
                TextField(
                  controller: authService.idTokenTextController,
                ),
                const Text('refresh token'),
                TextField(
                  controller: authService.refreshTokenTextController,
                ),
                const Text('test api results'),
                Text(authService.userInfo ?? ''),
                if (!kIsWeb) const Text('Operating system:'),
                if (!kIsWeb) Text(Platform.operatingSystem),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
