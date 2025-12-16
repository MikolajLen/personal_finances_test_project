import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finances/create/ui/create_transaction_page.dart';
import 'package:personal_finances/di/injector.dart';
import 'package:personal_finances/list/cubit/transactions_list_cubit.dart';
import 'package:personal_finances/list/ui/transactions_list_view.dart';
import 'package:personal_finances/utils/clock.dart';

class TransactionsListPage extends StatelessWidget {
  const TransactionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Personal Finances'),
      ),
      body: BlocProvider(
        create: (context) => getIt<TransactionsListCubit>(),
        child: BlocBuilder<TransactionsListCubit, TransactionsListState>(
          builder: (context, state) {
            return TransactionsListView(
              transactions: state.data.transactions,
              balance: state.data.balance,
              clock: SystemClock(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(CreateTransactionPage.createTransactionRoute);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  static const transactionsListRoute = '/';
  static const transactionsListName = 'transactions';
}
