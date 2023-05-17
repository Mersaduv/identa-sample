class ServiceConfig {
  ServiceConfig._();

  static const String baseURL = 'https://jsonplaceholder.typicode.com';
  static Uri aiAPIUri = Uri.parse('${ServiceConfig.baseURL}/ai?=');
  static Uri usersAPIUri = Uri.parse('${ServiceConfig.baseURL}/users');
  static Uri postsAPIUri = Uri.parse('${ServiceConfig.baseURL}/posts');
  static Uri loginAPIUri = Uri.parse('${ServiceConfig.baseURL}/login');
}
