import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class AccountModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String accountNumber;
  
  @HiveField(3)
  final double balance;

  AccountModel({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
