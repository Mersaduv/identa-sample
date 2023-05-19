class ServiceConfig {
  ServiceConfig._();

  static const String baseURL = 'https://api.identa.me';
  static Uri chatAPIUri = Uri.parse('${ServiceConfig.baseURL}/chat');

}
