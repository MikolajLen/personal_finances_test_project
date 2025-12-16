import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/repository/transactions_repository.dart';

part 'create_transaction_state.dart';

@injectable
class CreateTransactionCubit extends Cubit<CreateTransactionState> {
  final TransactionsRepository repository;

  final formKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  CreateTransactionCubit(this.repository)
    : super(const CreateTransactionState(categories: [])) {
    repository.loadCategories().then(
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  void setCategory(String? value) {
    emit(state.copyWith(category: value?.trim()));
  }

  void addCategoryAndSelect(String value) {
    final typed = value.trim();
    if (typed.isEmpty) return;

    final newList = List<String>.from(state.categories);
    if (!newList.contains(typed)) newList.add(typed);

    emit(state.copyWith(categories: newList, category: typed));
  }

  void setType(TransactionType? value) {
    emit(state.copyWith(type: value));
  }

  void setDate(DateTime? value) {
    emit(state.copyWith(date: value));
  }

  void validateAndSave() {
    emit(state.copyWith(showExtraErrors: true));

    final formOk = formKey.currentState?.validate() ?? false;
    final extrasOk = state.type != null && state.date != null;

    if (!formOk || !extrasOk) return;


    final category = state.category!;
    final amount = double.parse(
      amountController.text.trim().replaceAll(',', '.'),
    );
    final notes = notesController.text.trim();
    final transactionType = state.type!;
    final date = state.date!;

    final transaction = Transaction(amount, category, date, transactionType, notes.isEmpty ? null : notes);
    repository.insertTransaction(transaction).then((_) => emit(state.copyWith(navigateBack: true)));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    amountController.dispose();
    notesController.dispose();
    return super.close();
  }
}
