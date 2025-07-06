// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connected_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectedAccount _$ConnectedAccountFromJson(Map<String, dynamic> json) =>
    ConnectedAccount(
      id: json['id'] as String,
      accountNumber: json['accountNumber'] as String?,
      bsb: json['bsb'] as String?,
      institutionName: json['institutionName'] as String?,
      accountName: json['accountName'] as String?,
      accountType: json['accountType'] as String?,
      balance: (json['balance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      lastRefresh: json['lastRefresh'] == null
          ? null
          : DateTime.parse(json['lastRefresh'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$ConnectedAccountToJson(ConnectedAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountNumber': instance.accountNumber,
      'bsb': instance.bsb,
      'institutionName': instance.institutionName,
      'accountName': instance.accountName,
      'accountType': instance.accountType,
      'balance': instance.balance,
      'currency': instance.currency,
      'lastRefresh': instance.lastRefresh?.toIso8601String(),
      'isActive': instance.isActive,
    };