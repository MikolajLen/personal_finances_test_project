import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finances/create/ui/create_transaction_page.dart';
import 'package:personal_finances/di/injector.dart';
import 'package:personal_finances/list/ui/transactions_list_page.dart';

void main() {
  configureDependencies();  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
    return  MaterialApp.router(
      routerConfig: appRouter,
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: TransactionsListPage.transactionsListRoute,
  routes: [
    GoRoute(
      path: TransactionsListPage.transactionsListRoute,
      name: TransactionsListPage.transactionsListName,
      builder: (context, state) => const TransactionsListPage(),
    ),
    GoRoute(
      path: CreateTransactionPage.createTransactionRoute,
      name: CreateTransactionPage.createTransactionName,
      builder: (context, state) => const CreateTransactionPage(),
    ),
  ],
);