part of 'create_transaction_cubit.dart';

class CreateTransactionState extends Equatable {
    final List<String> categories;
  final String? category;
  final DateTime? date;
  final TransactionType? type;
  final bool showExtraErrors;
  final bool navigateBack;

  const CreateTransactionState({
    required this.categories,
    this.category,
    this.date,
    this.type,
    this.showExtraErrors = false,
    this.navigateBack = false
  });

  CreateTransactionState copyWith({
    List<String>? categories,
    String? category,
    DateTime? date,
    TransactionType? type,
    bool? showExtraErrors,
    bool? navigateBack
  }) {
    return CreateTransactionState(
      categories: categories ?? this.categories,
      category: category ?? this.category,
      date: date ?? this.date,
      type: type ?? this.type,
      showExtraErrors: showExtraErrors ?? this.showExtraErrors,
      navigateBack: navigateBack ?? this.navigateBack
    );
  }

  @override
  List<Object> get props => [categories, ?category, ?date, ?type, showExtraErrors, navigateBack];
}