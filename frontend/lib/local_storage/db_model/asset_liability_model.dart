import 'package:hive_ce/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'asset_liability_model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class AssetLiabilityModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final bool isAsset; // true for asset, false for liability

  AssetLiabilityModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.isAsset,
  });

  factory AssetLiabilityModel.fromJson(Map<String, dynamic> json) => _$AssetLiabilityModelFromJson(json);
  Map<String, dynamic> toJson() => _$AssetLiabilityModelToJson(this);
}
