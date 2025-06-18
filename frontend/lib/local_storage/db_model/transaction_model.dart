import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class TransactionModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String description;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final DateTime date;
  
  @HiveField(4)
  final String? category;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    this.category,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
