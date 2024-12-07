import 'package:flutter/material.dart';

class CurrencyDropdown extends StatelessWidget {
  final String selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CurrencyDropdown({
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
