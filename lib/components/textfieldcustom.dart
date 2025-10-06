import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rota_da_fe/style/colors.dart';
import 'package:rota_da_fe/style/textstyles.dart';

Widget TextFieldCustom(
    {enabled = true,
    obscureText = false,
    required TextInputType keyboardType,
    required String labelText,
    required TextEditingController controller,
    required double width,
    isNumber = false}) {
  return SizedBox(
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
                    TextFormField(
                      obscureText: obscureText,
                      enabled: enabled,
                      maxLength: isNumber ? 3 : 256,
                      controller: controller,
                      keyboardType: keyboardType,
                      inputFormatters: isNumber
                          ? <TextInputFormatter>[
                              FilteringTextInputFormatter
                                  .digitsOnly,  
                            ]
                          : [],
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
                        labelText: "Digite $labelText",
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppColors.secondary,
                          ),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
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
