/// App constants for the chat application
class AppConstants {
  // API Base URL
  static const String baseUrl = 'https://parking.api.salonsyncs.com';

  // API Endpoints
  static const String loginEndpoint = '/api/machine-test/login';
  static const String vehicleListEndpoint = '/api/machine-test/list';
  static const String vehicleCreateEndpoint = '/api/machine-test/create';
  static const String vehicleUpdateEndpoint = '/api/machine-test/edit';
  static const String vehicleDeleteEndpoint = '/api/machine-test/delete';

  // Hardcoded Credentials
  static const String defaultMobileNumber = '9895680203';
  static const String defaultPassword = '123456';

  // App Constants
  static const String appName = 'Parking Management App';
  static const int pageSize = 10;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
}
