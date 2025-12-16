import 'package:flutter/material.dart';
import 'package:personal_finances/create/cubit/create_transaction_cubit.dart';
import 'package:personal_finances/create/ui/decimal_text_input_formatter.dart';
import 'package:personal_finances/create/ui/transaction_category_selector.dart';
import 'package:personal_finances/create/ui/transaction_date_picker.dart';
import 'package:personal_finances/create/ui/transaction_section_header.dart';
import 'package:personal_finances/create/ui/transaction_type_selector.dart';
import 'package:personal_finances/repository/transaction.dart';
import 'package:personal_finances/utils/clock.dart';

class CreateTransactionView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController searchController;
  final TextEditingController amountController;
  final TextEditingController notesController;
  final void Function(String?) setCategory;
  final void Function(String) addCategoryAndSelect;
  final void Function(DateTime) setDate;
  final ValueChanged<TransactionType?> onTransactionTypeChanged;
  final void Function(TransactionType?) setType;
  final CreateTransactionState state;
  final VoidCallback validate;

  const CreateTransactionView({
    super.key,
    required this.formKey,
    required this.searchController,
    required this.amountController,
    required this.notesController,
    required this.setCategory,
    required this.addCategoryAndSelect,
    required this.setDate,
    required this.onTransactionTypeChanged,
    required this.setType,
    required this.state,
    required this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Transaction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TransactionSectionHeader(sectionTitle: 'Select category'),
              TransactionCategorySelector(
                categories: state.categories,
                category: state.category,
                searchController: searchController,
                setCategory: setCategory,
                addCategoryAndSelect: addCategoryAndSelect,
              ),
              TransactionSectionHeader(sectionTitle: 'Select amount'),
              TextFormField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                validator: (value) {
                  if ((value ?? '').trim().isEmpty) {
                    return 'Amount cannot be empty';
                  }
                  if (value != null) {
                    final amount = double.parse(
                      value.trim().replaceAll(',', '.'),
                    );
                    return amount > 0 ? null : 'Amount must be greater then 0';
                  }
                  return null;
                },
              ),
              TransactionSectionHeader(sectionTitle: 'Select transaction type'),
              TransactionTypeSelector(
                groupValue: state.type,
                onChanged: (TransactionType? value) {
                  setType(value);
                },
                setType: (type) {
                  setType(type);
                },
              ),
              if (state.showExtraErrors && state.type == null)
                Text(
                  'Transaction type is required!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),

              TransactionSectionHeader(sectionTitle: 'Select transaction date'),
              TransactionDatePicker(
                date: state.date,
                clock: SystemClock(),
                setDate: (transactionDate) => {setDate(transactionDate)},
              ),
              if (state.showExtraErrors && state.date == null)
                Text(
                  'Transaction date is required!',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              TransactionSectionHeader(sectionTitle: 'Add optional notes'),
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => validate(),
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
