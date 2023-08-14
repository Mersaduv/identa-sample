import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mutex/mutex.dart';

class AuthService {
  static var _refreshToken = '';
  static var _accessToken = '';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    // get refresh token from secure storage
    final m = Mutex();
    await m.acquire();
    try {
      _refreshToken = await _secureStorage.read(key: 'refresh_token') ?? '';
    } catch (e) {}
    // try to refresh token
    if (_refreshToken.isNotEmpty) {
      TokenResponse? refreshTokenResult;
      try {
        refreshTokenResult = await _appAuth.token(TokenRequest(
          _clientId,
          _redirectUrl,
          clientSecret: "dkDkIt9APGFWtI7fFq7aVp5I1U1rCAWE",
          refreshToken: _refreshToken,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes,
        ));
      } catch (ex) {}
      if (refreshTokenResult != null) {
        _setTokens(refreshTokenResult);

        return true;
      }
    }
    try {
      AuthorizationTokenResponse? result =
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
      if (result != null) {
        _idToken = result.idToken;
        _setTokens(result);

        return true;
      }
    } catch (e) {
      print(e);
    }
    m.release();

    return false;
  }

  Future<void> signOut() async {
    try {
      // Clear tokens from secure storage and memory
      await _secureStorage.delete(key: 'refresh_token');
      _refreshToken = '';
      _accessToken = '';
      _idToken = null;
      const AuthorizationServiceConfiguration serviceConfiguration =
          AuthorizationServiceConfiguration(
        authorizationEndpoint:
            'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
        tokenEndpoint:
            'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
        endSessionEndpoint:
            'https://auth.tooskatech.com/realms/identa/protocol/openid-connect/logout',
      );

      await _appAuth.endSession(EndSessionRequest(
        idTokenHint: _idToken,
        serviceConfiguration: serviceConfiguration,
      ));
    } catch (e) {
      await getAuthHeader();

      print(e);
    }
  }

  void _setTokens(TokenResponse result) {
    _refreshToken = result.refreshToken!;
    _accessToken = result.accessToken!;

    // save refresh token to secure storage
    _secureStorage.write(key: 'refresh_token', value: _refreshToken);
  }

  Future<String> getAuthHeader() async {
    if (_accessToken.isEmpty) {
      await signInWithAutoCodeExchange();
    }
    return "Bearer $_accessToken";
  }
}
