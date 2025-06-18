import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class GoalModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double targetAmount;
  
  @HiveField(3)
  final double currentAmount;
  
  @HiveField(4)
  final DateTime? targetDate;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
  });

  factory GoalModel.fromJson(Map<String, dynamic> json) => _$GoalModelFromJson(json);
  Map<String, dynamic> toJson() => _$GoalModelToJson(this);
}
