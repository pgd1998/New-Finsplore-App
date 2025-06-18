// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_liability_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetLiabilityModelAdapter extends TypeAdapter<AssetLiabilityModel> {
  @override
  final int typeId = 2;

  @override
  AssetLiabilityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetLiabilityModel(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: (fields[2] as num).toDouble(),
      isAsset: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AssetLiabilityModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.isAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetLiabilityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetLiabilityModel _$AssetLiabilityModelFromJson(Map<String, dynamic> json) =>
    AssetLiabilityModel(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      isAsset: json['isAsset'] as bool,
    );

Map<String, dynamic> _$AssetLiabilityModelToJson(
        AssetLiabilityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'isAsset': instance.isAsset,
    };
