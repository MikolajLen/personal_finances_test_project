import 'package:flutter/material.dart';
import 'package:personal_finances/di/injector.dart';
import 'package:personal_finances/list/cubit/transactions_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:personal_finances/list/ui/transactions_list_view.dart';
import 'package:personal_finances/utils/clock.dart';

void main() {
  configureDependencies();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Finances',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AppView(title: 'Personal Finances')
    );
  }
}

class AppView extends StatelessWidget {

  final String title;

  const AppView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: BlocProvider(
        create: (context) => getIt<TransactionsListCubit>(),
        child: BlocBuilder<TransactionsListCubit, TransactionsListState>(
          builder: (context, state) {
            return TransactionsListView(transactions: state.data.transactions, balance: state.data.balance, clock: SystemClock());
          },
        ),
      ),
    );
  }
}
