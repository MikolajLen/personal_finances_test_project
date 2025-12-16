import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'transactions_database.g.dart';

class TransactionItem extends Table {
   IntColumn get id => integer().autoIncrement()();
   RealColumn get amount => real()();
   TextColumn get category => text()();
   IntColumn get transactionDate => integer()();
   TextColumn get notes => text().nullable()();
}

@DriftDatabase(tables: [TransactionItem])
class TransactionsDatabase extends _$TransactionsDatabase {
    
    TransactionsDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

    int get schemaVersion => 1;

    static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}