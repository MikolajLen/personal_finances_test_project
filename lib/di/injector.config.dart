// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../create/cubit/create_transaction_cubit.dart' as _i225;
import '../database/database_module.dart' as _i215;
import '../database/transactions_dao.dart' as _i647;
import '../database/transactions_database.dart' as _i393;
import '../list/cubit/transactions_list_cubit.dart' as _i580;
import '../repository/transactions_repository.dart' as _i334;
import '../repository/transactions_repository_impl.dart' as _i775;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    gh.singleton<_i393.TransactionsDatabase>(
      () => databaseModule.provideDatabase(),
    );
    gh.lazySingleton<_i647.TransactionsDao>(
      () => _i647.TransactionsDao(gh<_i393.TransactionsDatabase>()),
    );
    gh.lazySingleton<_i334.TransactionsRepository>(
      () => _i775.TransactionsRepositoryImpl(gh<_i647.TransactionsDao>()),
    );
    gh.factory<_i580.TransactionsListCubit>(
      () => _i580.TransactionsListCubit(gh<_i334.TransactionsRepository>()),
    );
    gh.factory<_i225.CreateTransactionCubit>(
      () => _i225.CreateTransactionCubit(gh<_i334.TransactionsRepository>()),
    );
    return this;
  }
}

class _$DatabaseModule extends _i215.DatabaseModule {}
