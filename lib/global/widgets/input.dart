import 'package:angel_car/global/utils/app-colors.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';

class Input extends StatefulWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmited;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final bool? enable;

  const Input(
      {Key? key,
      this.controller,
      this.validator,
      this.hint,
      this.onTap,
      this.onFieldSubmited,
      this.keyboardType,
      this.textInputAction,
      this.maxLength,
      this.enable = true})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  bool isVisible = false;
  bool isPassword = false;
  bool isDocument = false;
  bool isDateBirth = false;
  bool isPhone = false;
  final screenHeight = Get.height;

  get onFieldSubmited => widget.onFieldSubmited;

  @override
  Widget build(BuildContext context) {
    if (widget.hint != null) {
      if (widget.hint!.toLowerCase().contains("senha")) {
        isPassword = true;
      } else {
        isPassword = false;
      }

      if (widget.hint!.toLowerCase().contains("celular")) {
        isPhone = true;
      } else {
        isPhone = false;
      }

      if (widget.hint!.toLowerCase().contains("cpf")) {
        isDocument = true;
      } else {
        isDocument = false;
      }

      if (widget.hint!.toLowerCase().contains("nascimento")) {
        isDateBirth = true;
      } else {
        isDateBirth = false;
      }
    }

    return Container(
      color: AppColors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, bottom: 8.0),
            child: Text(
              widget.hint ?? '',
              style: AppTextStyles.robotoRegular(
                  color: AppColors.gray, size: 14.0),
            ),
          ),
          TextFormField(
              onFieldSubmitted: onFieldSubmited,
              enabled: widget.enable,
              inputFormatters: [
                isDocument
                    ? TextInputMask(mask: ['999.999.999-99'], reverse: false)
                    : isDateBirth
                        ? TextInputMask(mask: ['99/99/9999'], reverse: false)
                        : isPhone
                            ? TextInputMask(mask: [
                                '(99) 9999 - 9999',
                                '(99) 9 9999 - 9999'
                              ], reverse: false)
                            : TextInputMask(mask: 'X*', reverse: false)
              ],
              obscureText: isPassword ? !isVisible : false,
              textInputAction: widget.textInputAction,
              onTap: widget.onTap,
              keyboardType: widget.keyboardType,
              controller: widget.controller,
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 32.0, right: 32.0),
                fillColor: AppColors.grayLight,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide:
                      const BorderSide(color: AppColors.grayLight, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide:
                      const BorderSide(color: AppColors.grayLight, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide:
                      const BorderSide(color: AppColors.grayLight, width: 1.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1000.0),
                  borderSide: const BorderSide(color: AppColors.red, width: 1.0),
                ),
                suffixIcon: isPassword
                    ? isVisible
                        ? IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.visibility_off,
                              color: AppColors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                          )
                    : null,
                // labelText: widget.hint,
                labelStyle: const TextStyle(color: AppColors.primary),
              ),
              textAlign: TextAlign.start,
              style: AppTextStyles.robotoRegular(
                  color: AppColors.white, size: 18.0),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validator),
        ],
      ),
    );
  }
}
