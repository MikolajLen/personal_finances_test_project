import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:personal_finances/create/cubit/create_transaction_cubit.dart';
import 'package:personal_finances/create/ui/create_transaction_view.dart';
import 'package:personal_finances/di/injector.dart';

class CreateTransactionPage extends StatelessWidget {
  const CreateTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Create transaction'),
      ),
      body: BlocProvider(
        create: (context) => getIt<CreateTransactionCubit>(),
        child: BlocListener<CreateTransactionCubit, CreateTransactionState>(
          listener: (context, state) {
            if(state.navigateBack) {
              context.pop();
            }
          },
          child: BlocBuilder<CreateTransactionCubit, CreateTransactionState>(
            builder: (context, state) {
              final cubit = context.read<CreateTransactionCubit>();
              return CreateTransactionView(
                formKey: cubit.formKey,
                searchController: cubit.searchController,
                amountController: cubit.amountController,
                notesController: cubit.notesController,
                setCategory: cubit.setCategory,
                addCategoryAndSelect: cubit.addCategoryAndSelect,
                setDate: cubit.setDate,
                onTransactionTypeChanged: cubit.setType,
                setType: cubit.setType,
                state: state,
                validate: cubit.validateAndSave,
              );
            },
          ),
        ),
      ),
    );
  }

  static const createTransactionRoute = '/create';
  static const createTransactionName = 'createTransaction';
}
