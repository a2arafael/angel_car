import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-colors.dart';

Widget tffSubject({
  TextEditingController? subjectController,
  FormFieldValidator<String>? validator,
}) {
  return TextFormField(
        textInputAction: TextInputAction.next,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            ), 
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.0),
            ),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.0),
            ),
            labelText: 'Motivo do contato',
            labelStyle: const TextStyle(color: AppColors.primary),
            
            ),
        textAlign: TextAlign.start,
        style: const TextStyle(color: AppColors.black, fontSize: 18.0),
        controller: subjectController,
        validator: validator,
      );
}
