import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.mobileNumber,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle the actual API response structure
    if (json.containsKey('user') && json.containsKey('accessToken')) {
      // New API response format
      final userData = json['user'] as Map<String, dynamic>;
      return UserModel(
        id: userData['_id']?.toString() ?? '',
        name: userData['_name'] ?? '',
        email: '', // API doesn't provide email
        mobileNumber: userData['_mobileNumber'] ?? '',
        token: json['accessToken'],
      );
    } else {
      // Fallback to old format
      return UserModel(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        mobileNumber: json['mobile_number'] ?? '',
        token: json['token'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'token': token,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      mobileNumber: user.mobileNumber,
      token: user.token,
    );
  }
}
