part of 'transactions_list_cubit.dart';

class TransactionsListState extends Equatable {

  final FinancialData data;

  const TransactionsListState(this.data);

  @override
  List<Object> get props => [data];
}
