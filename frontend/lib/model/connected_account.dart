import 'package:json_annotation/json_annotation.dart';

part 'connected_account.g.dart';

@JsonSerializable()
class ConnectedAccount {
  final String id;
  final String? accountNumber;
  final String? bsb;
  final String? institutionName;
  final String? accountName;
  final String? accountType;
  final double? balance;
  final String? currency;
  final DateTime? lastRefresh;
  final bool isActive;

  ConnectedAccount({
    required this.id,
    this.accountNumber,
    this.bsb,
    this.institutionName,
    this.accountName,
    this.accountType,
    this.balance,
    this.currency,
    this.lastRefresh,
    this.isActive = true,
  });

  factory ConnectedAccount.fromJson(Map<String, dynamic> json) =>
      _$ConnectedAccountFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectedAccountToJson(this);

  String get displayName => accountName ?? 'Account ${accountNumber ?? id}';
  
  String get bankDisplay => institutionName ?? 'Bank';
  
  String get accountDisplay => 
      '${accountType ?? 'Account'} ${accountNumber != null ? '***${accountNumber!.substring(accountNumber!.length - 4)}' : ''}';
  
  String get balanceDisplay => 
      '${currency ?? 'AUD'} ${balance?.toStringAsFixed(2) ?? '0.00'}';
}