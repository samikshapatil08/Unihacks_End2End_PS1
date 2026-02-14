/// Base URL for the Django backend. Change for production or use env.
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'https://unihacks-end2end-ps1.onrender.com',
    defaultValue: 'http://localhost:8000',
  );
}
