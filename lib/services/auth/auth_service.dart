import 'package:flutter_appauth/flutter_appauth.dart';

class AuthService {
  final String _clientId = 'chat-api';
  final String _redirectUrl = 'com.tooskatech.identa:/oauthredirect';
  final String _discoveryUrl =
      'https://auth.tooskatech.com/realms/identa/.well-known/openid-configuration';

  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access'
  ];
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  // constructor
  AuthService() {
    // initialize the authorization service configuration
  }

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

    return result;
  }

  // void _processAuthTokenResponse(TokenResponse? response) {
  //   var accessToken = response!.accessToken!;
  //   var idToken = response.idToken!;
  //   var refreshToken = response.refreshToken!;
  //   var tokeExpiry = response.accessTokenExpirationDateTime!.toIso8601String();
  // }
}
