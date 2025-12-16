import 'package:flutter/material.dart';

class TransactionSectionHeader extends StatelessWidget {
  final String sectionTitle;

  const TransactionSectionHeader({super.key, required this.sectionTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Text(sectionTitle, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
      ],
    );
  }
}