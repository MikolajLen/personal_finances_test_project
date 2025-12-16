import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finances/repository/financial_data.dart';
import 'package:personal_finances/repository/transactions_repository.dart';

part 'transactions_list_state.dart';

@injectable
class TransactionsListCubit extends Cubit<TransactionsListState> {

  final TransactionsRepository _repository;
  StreamSubscription<FinancialData>? _subscription;

  TransactionsListCubit(this._repository) : super(TransactionsListState(_initalData)) {
    _subscription = _repository.loadFinancialData().listen((data) => emit(TransactionsListState(data)));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

const _initalData = FinancialData([], 0.0);
