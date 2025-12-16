import 'package:injectable/injectable.dart';
import 'package:personal_finances/database/transactions_database.dart';

@module
abstract class DatabaseModule {
  
  @singleton
  TransactionsDatabase provideDatabase() {
    return TransactionsDatabase();
  }
}