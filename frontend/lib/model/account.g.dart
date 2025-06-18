// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      email: json['email'] as String,
      password: json['password'] as String?,
      username: json['username'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      middleName: json['middleName'] as String?,
      userId: json['userId'] as String?,
      token: json['token'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'username': instance.username,
      'phoneNumber': instance.phoneNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'middleName': instance.middleName,
      'userId': instance.userId,
      'token': instance.token,
      'isEmailVerified': instance.isEmailVerified,
      'isActive': instance.isActive,
    };
