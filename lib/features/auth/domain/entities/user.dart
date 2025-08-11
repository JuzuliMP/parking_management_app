import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String? token;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    this.token,
  });

  @override
  List<Object?> get props => [id, name, email, mobileNumber, token];

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? mobileNumber,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      token: token ?? this.token,
    );
  }
}
