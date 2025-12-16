import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class TransactionCategorySelector extends StatelessWidget {
  final List<String> categories;
  final String? category;
  final TextEditingController searchController;
  final void Function(String?) setCategory;
  final void Function(String) addCategoryAndSelect;

  const TransactionCategorySelector({
    super.key,
    required this.categories,
    required this.category,
    required this.searchController,
    required this.setCategory,
    required this.addCategoryAndSelect,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: (filter, infiniteScrollProps) => categories,
      selectedItem: category,
      popupProps: PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search or add new category',
          ),
        ),

        emptyBuilder: (context, searchEntry) {
          final typed = searchController.text.trim();
          if (typed.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: Text('No results'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  addCategoryAndSelect(typed);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.add),
                label: Text('Add „$typed”'),
              ),
            ),
          );
        },
      ),
      decoratorProps: const DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: 'Category',
          hintText: 'Select category or type down below',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.zero),
          ),
        ),
      ),
      validator: (value) {
        if ((value ?? '').trim().isEmpty) return 'Select category';
        return null;
      },
      onChanged: setCategory,
      onSaved: (v) => setCategory(v),
    );
  }
}
