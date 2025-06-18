// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// HiveTypeAdapter registrar
// **************************************************************************

import 'package:hive_ce/hive.dart';
import 'package:finsplore/local_storage/db_model/transaction_model.dart';
import 'package:finsplore/local_storage/db_model/goal_model.dart';
import 'package:finsplore/local_storage/db_model/asset_liability_model.dart';
import 'package:finsplore/local_storage/db_model/account_model.dart';

extension HiveRegistrar on HiveInterface {
  void registerAdapters() {
    // Register type adapters for Hive models
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(GoalModelAdapter());
    Hive.registerAdapter(AssetLiabilityModelAdapter());
    Hive.registerAdapter(AccountModelAdapter());
  }
}
