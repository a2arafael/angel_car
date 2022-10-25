import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:angel_car/global/utils/app-colors.dart';

Widget tfdMessage({
  TextEditingController? messageController,
  FormFieldValidator<String>? validator,
  int? messageLength
}) {
  return TextFormField(
    textInputAction: TextInputAction.done,
    maxLength: messageLength,
    keyboardType: TextInputType.multiline,
    textCapitalization: TextCapitalization.sentences,
    maxLines: null,
    cursorColor: AppColors.primary,
    inputFormatters:[
      LengthLimitingTextInputFormatter(messageLength),
    ],
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
      labelText: 'Mensagem',
      labelStyle: const TextStyle(color: AppColors.primary),
    ),
    textAlign: TextAlign.start,
    style: const TextStyle(color: AppColors.black, fontSize: 18.0),
    controller: messageController,
    validator: validator,
  );
}
