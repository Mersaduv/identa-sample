import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static var _refreshToken = '';
  static var _accessToken = '';
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
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    // get refresh token from secure storage
    _secureStorage.read(key: 'refresh_token').then((value) {
      if (value != null) {
        _refreshToken = value;
      }
    });

    // try to refresh token
    if (_refreshToken.isNotEmpty) {
      var refreshTokenResult = await _appAuth.token(TokenRequest(
        _clientId,
        _redirectUrl,
        refreshToken: _refreshToken,
        discoveryUrl: _discoveryUrl,
        scopes: _scopes,
      ));

      if (refreshTokenResult != null) {
        _setTokens(refreshTokenResult);

        return true;
      }
    }

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
    if (result != null) {
      _setTokens(result);

      return true;
    }

    return false;
  }

  void _setTokens(TokenResponse result) {
    _refreshToken = result.refreshToken!;
    _accessToken = result.accessToken!;

    // save refresh token to secure storage
    _secureStorage.write(key: 'refresh_token', value: _refreshToken);
  }

  String getAuthHeader() {
    return "Bearer $_accessToken";
  }
}
