import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';

Widget DropdownButtonForm({
  required String labelText,
  required List<String> items,
  required TextEditingController controller,
  required String initialValue,
  required double width,
  required Function onChanged,
}) {
  // Remove duplicatas e garante que o initialValue está presente apenas uma vez
  final List<String> uniqueItems = [
    initialValue,
    ...items.where((e) => e != initialValue)
  ];

  return SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Row(
            children: [
              Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 0),
                  SizedBox(
                      width: 50,
                      child: Image.asset("images/icon_santinha.png")),
                ],
              ),
              const SizedBox(width: 0),
              Expanded(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(labelText,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: uniqueItems.contains(controller.text)
                          ? controller.text
                          : initialValue,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_downward),
                      isExpanded: true,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.text = newValue;
                        }
                        onChanged();
                      },
                      items: uniqueItems
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
