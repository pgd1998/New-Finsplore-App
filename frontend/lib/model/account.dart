import 'package:json_annotation/json_annotation.dart';
import 'package:finsplore/model/model.dart';

part 'account.g.dart';

@JsonSerializable()
class Account extends Model<Account> {
  final String email;
  final String? password; // Optional for security (not always included in responses)
  final String? username;
  final String? phoneNumber;
  final String? firstName;
  final String? lastName;
  final String? middleName;
  final String? userId;
  final String? token;
  final bool? isEmailVerified;
  final bool? isActive;

  Account({
    required this.email,
    this.password,
    this.username,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.middleName,
    this.userId,
    this.token,
    this.isEmailVerified,
    this.isActive,
  });

  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$AccountToJson(this);

  @override
  String get id => userId ?? email;

  /// Create a copy with updated fields
  @override
  Account copyWith({
    String? email,
    String? password,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? middleName,
    String? userId,
    String? token,
    bool? isEmailVerified,
    bool? isActive,
  }) {
    return Account(
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
    );
  }

  /// Get display name
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (username != null && username!.isNotEmpty) {
      return username!;
    }
    return email;
  }

  /// Get full name
  String get fullName {
    List<String> nameParts = [];
    if (firstName != null) nameParts.add(firstName!);
    if (middleName != null && middleName!.isNotEmpty) nameParts.add(middleName!);
    if (lastName != null) nameParts.add(lastName!);
    return nameParts.join(' ');
  }

  @override
  String toString() {
    return 'Account(email: $email, username: $username, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Account && other.email == email && other.userId == userId;
  }

  @override
  int get hashCode => email.hashCode ^ userId.hashCode;
}
