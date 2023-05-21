import 'package:flutter_appauth/flutter_appauth.dart';

class AuthService {
  final String _clientId = 'chat-api';
  final String _redirectUrl = 'com.tooskatech.identa:/oauthredirect';
  final String _discoveryUrl =
      'https://auth.tooskatech.com/realms/identa/.well-known/openid-configuration';
  String? _idToken;
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access'
  ];
  final FlutterAppAuth _appAuth = const FlutterAppAuth();

  Future<AuthorizationTokenResponse?> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    final AuthorizationTokenResponse? result =
        await _appAuth.authorizeAndExchangeCode(
      AuthorizationTokenRequest(
        _clientId,
        _redirectUrl,
        clientSecret: "dkDkIt9APGFWtI7fFq7aVp5I1U1rCAWE",
        discoveryUrl: _discoveryUrl,
        scopes: _scopes,
        preferEphemeralSession: preferEphemeralSession,
      ),
    );
    _idToken = result?.idToken;
    return result;
  }

  // Future<void> logOut() async {
  //   try {
  //     await _appAuth.endSession(EndSessionRequest(
  //         idTokenHint: _idToken ?? "",
  //         postLogoutRedirectUrl: _redirectUrl,
  //         serviceConfiguration: const AuthorizationServiceConfiguration(
  //             authorizationEndpoint:
  //                 'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
  //             tokenEndpoint:
  //                 'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
  //             endSessionEndpoint:
  //                 'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout')));
  //   } catch (e) {
  //     print(e);
  //   }
  //   _idToken = null;
  // }

  Future<void> logOut() async {
    try {
      await _appAuth.endSession(EndSessionRequest(
          idTokenHint: _idToken,
          serviceConfiguration: const AuthorizationServiceConfiguration(
              authorizationEndpoint:
                  'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
              tokenEndpoint:
                  'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
              endSessionEndpoint:
                  'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout')));
    } catch (e) {
      print(e);
    }
  }
}
