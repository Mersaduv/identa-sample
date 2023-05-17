import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier, DiagnosticableTreeMixin {
  bool _isBusy = false;

  bool get isBusy => _isBusy;
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  String? _codeVerifier;
  String? _nonce;
  String? _authorizationCode;
  String? _refreshToken;
  String? _accessToken;
  String? _idToken;
  String? _userInfo;
  String? get userInfo => _userInfo;
  set userInfo(String? value) {
    _userInfo = value;
    notifyListeners();
  }

  late TextEditingController _authorizationCodeTextController =
      TextEditingController();
  TextEditingController get authorizationCodeTextController =>
      _authorizationCodeTextController;

  late TextEditingController _accessTokenTextController =
      TextEditingController();
  TextEditingController get accessTokenTextController =>
      _accessTokenTextController;

  late TextEditingController _accessTokenExpirationTextController =
      TextEditingController();
  TextEditingController get accessTokenExpirationTextController =>
      _accessTokenExpirationTextController;

  late TextEditingController _idTokenTextController = TextEditingController();
  TextEditingController get idTokenTextController => _idTokenTextController;

  late TextEditingController _refreshTokenTextController =
      TextEditingController();
  TextEditingController get refreshTokenTextController =>
      _refreshTokenTextController;

  final String _clientId = 'chat-api';
  final String _clientSecret = 'dkDkIt9APGFWtI7fFq7aVp5I1U1rCAWE';
  final String _redirectUrl = 'mycoolapp://auth';
  final String _issuer = 'https://auth.tooskatech.com/realms/identa';
  final String _discoveryUrl =
      'https://auth.tooskatech.com/realms/identa/.well-known/openid-configuration';
  final String _postLogoutRedirectUrl = 'de.icod.bicki:/';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
    'roles'
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration =
      const AuthorizationServiceConfiguration(
    authorizationEndpoint:
        'https://connect.icod.de/auth/realms/bicki/protocol/openid-connect/auth',
    tokenEndpoint:
        'https://connect.icod.de/auth/realms/bicki/protocol/openid-connect/token',
    endSessionEndpoint:
        'https://connect.icod.de/auth/realms/bicki/protocol/openid-connect/logout',
  );

  Future<void> endSession() async {
    try {
      _setBusyState();
      await _appAuth.endSession(EndSessionRequest(
          idTokenHint: _idToken,
          postLogoutRedirectUrl: _postLogoutRedirectUrl,
          serviceConfiguration: _serviceConfiguration));
      _clearSessionInfo();
    } catch (_) {}
    _clearBusyState();
  }

  void _clearSessionInfo() {
    _codeVerifier = null;
    _nonce = null;
    _authorizationCode = null;
    _accessToken = null;
    _idToken = null;
    _refreshToken = null;
    _userInfo = null;
  }

  Future<void> refresh() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: _refreshToken, issuer: _issuer, scopes: _scopes));
      _processTokenResponse(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> exchangeCode() async {
    try {
      _setBusyState();
      final TokenResponse? result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          authorizationCode: _authorizationCode,
          discoveryUrl: _discoveryUrl,
          codeVerifier: _codeVerifier,
          nonce: _nonce,
          scopes: _scopes));
      _processTokenResponse(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> signInWithNoCodeExchange() async {
    try {
      _setBusyState();
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl, scopes: _scopes, loginHint: 'user'),
      );

      // or just use the issuer
      // var result = await _appAuth.authorize(
      //   AuthorizationRequest(
      //     _clientId,
      //     _redirectUrl,
      //     issuer: _issuer,
      //     scopes: _scopes,
      //   ),
      // );
      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> signInWithNoCodeExchangeAndGeneratedNonce() async {
    try {
      _setBusyState();
      final Random random = Random.secure();
      final String nonce =
          base64Url.encode(List<int>.generate(16, (_) => random.nextInt(256)));
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse? result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl, scopes: _scopes, nonce: nonce),
      );

      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: _scopes,
          clientSecret: _clientSecret,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );
      // this code block demonstrates passing in values for the prompt parameter. in this case it prompts the user login even if they have already signed in. the list of supported values depends on the identity provider
      // final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(_clientId, _redirectUrl,
      //       serviceConfiguration: _serviceConfiguration,
      //       scopes: _scopes,
      //       promptValues: ['login']),
      // );

      if (result != null) {
        _processAuthTokenResponse(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    _isBusy = false;
    notifyListeners();
  }

  void _setBusyState() {
    _isBusy = true;
    notifyListeners();
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    _accessToken = response.accessToken!;
    _idToken = response.idToken!;
    _refreshToken = response.refreshToken!;
    notifyListeners();
  }

  void _processAuthResponse(AuthorizationResponse response) {
    // save the code verifier and nonce as it must be used when exchanging the token
    _codeVerifier = response.codeVerifier;
    _nonce = response.nonce;
    _authorizationCode = response.authorizationCode!;
    _isBusy = false;
    notifyListeners();
  }

  void _processTokenResponse(TokenResponse? response) {
    _accessToken = response!.accessToken!;
    _idToken = response.idToken!;
    _refreshToken = response.refreshToken!;
    notifyListeners();
  }

  Future<void> _testApi(TokenResponse? response) async {
    final http.Response httpResponse = await http.get(
        Uri.parse('https://demo.duendesoftware.com/api/test'),
        headers: <String, String>{'Authorization': 'Bearer $_accessToken'});
    void _setBusyState() {
      _userInfo = httpResponse.statusCode == 200 ? httpResponse.body : '';
      _isBusy = true;
      notifyListeners();
    }
  }

  String? get accessToken => _accessToken;
  String? get idToken => _idToken;
  String? get refreshToken => _refreshToken;
}
