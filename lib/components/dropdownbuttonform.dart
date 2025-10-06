import 'package:flutter/material.dart';
import 'package:rota_da_fe/style/colors.dart';
import 'package:rota_da_fe/style/textstyles.dart';

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

  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    width: width-100,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(labelText,
                            style: AppTextStyles.inputTitle)),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: uniqueItems.contains(controller.text)
                          ? controller.text
                          : initialValue,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      icon: Transform.translate(
                        offset: const Offset(10, -5),
                        child: const RotatedBox(
                            quarterTurns: 1, child: Icon(Icons.arrow_right, size: 35,)),
                      ),
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
