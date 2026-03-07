class ApiEndpoints {
  ApiEndpoints._();

  //Info: Base URL
  // static const String baseUrl = "http://10.0.2.2:5050"; // info: for android
  static const String baseUrl = "http://192.168.1.74:5050"; // info: for android
  // static const String baseUrl =
  //     "http://192.168.100.8:4000"; // info: for physical device use computers IP

  // Note: For physical device use computer IP: "http:/102.168.x.x:5000/api/v1"

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Hack: ========== User Endpoints ===========
  // static const String users = "/users";
  static const String userLogin = "/api/auth/login";
  static const String userRegister = "/api/auth/register";
  static const String userUploadPhoto = '/api/auth/profile';
  static const String userUpdate = '/api/auth/profile';
  static const String authorityStats = "/api/auth/authority-stats";
  // static String userById(String id) => '/users/$id';
  // static String userPhoto(String id) => "/users/$id/photo";

  // Add uploads path
  static const String uploadsPath = '/uploads';

  // Helper method to get full image URL
  static String getImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) return '';
    return '$baseUrl$uploadsPath/$filename';
    // result: http://192.168.1.74:5050/uploads/abc123.jpg
  }

  // issues ko
  static const String issues = "/api/issues";
  static const String issueUploadsPath = '/public/issue_images';
  // api_endpoints.dart - add these
  static const String reportStats = "/api/auth/report-stats";
  static const String myRecentIssues = "/api/issues/my-recent";
  static const String myIssues = "/api/issues/my-issues";
  static const String myAssignedIssues = "/api/issues/my-assigned";

  static String getIssueImageUrl(String? filename) {
    if (filename == null || filename.isEmpty) return '';
    return '$baseUrl$issueUploadsPath/$filename';
  }
}
