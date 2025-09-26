import 'package:flutter/material.dart';

class DropdownFieldCustom extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<String> items;  
  final String? selectedItem;  
  final ValueChanged<String?>? onChanged;  

  const DropdownFieldCustom({
    super.key,
    required this.icon,
    required this.label,
    required this.items,
    this.selectedItem,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        value: selectedItem,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
