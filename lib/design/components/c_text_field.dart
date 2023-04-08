import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fts_mobile/design/components/measure_size.dart';
import 'package:get/state_manager.dart';

import '/design/utils/design_utils.dart';

class CTextField extends StatefulWidget {
  final bool readOnly;
  final String labelText;
  final String? helperText;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final String? prefixIcon;
  final String? suffixText;
  final void Function()? onTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CTextField({
    Key? key,
    this.readOnly = false,
    required this.labelText,
    this.prefixIcon,
    this.helperText,
    this.focusNode,
    this.onTap,
    this.suffixText,
    this.suffixIcon,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  final BorderRadius borderRadius = const BorderRadius.only(
    topRight: Radius.circular(10),
    bottomRight: Radius.circular(10),
  );

  RxDouble containerHeight = 0.0.obs;

  @override
  Widget build(BuildContext context) {
    //TODO: Fix the design
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Container(
            width: 9,
            height: containerHeight.value,
            decoration: BoxDecoration(
              color: getPrimaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              border: Border.all(color: getColor1.withOpacity(.33)),
            ),
          ),
        ),
        Expanded(
          child: MeasureSize(
            onChange: (Size size) {
              if (containerHeight.value == 0.0) {
                setState(() {
                  containerHeight.value = size.height;
                });
              }
            },
            child: TextFormField(
              onTap: widget.onTap,
              validator: widget.validator,
              controller: widget.controller,
              focusNode: widget.focusNode,
              readOnly: widget.readOnly,
              keyboardType: widget.keyboardType,
              scrollPhysics: defaultPhysics,
              textInputAction: widget.textInputAction,
              inputFormatters: widget.inputFormatters,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: widget.labelText,
                suffixIcon: widget.suffixIcon,
                hintStyle: TextThemeX.text14.copyWith(
                  fontWeight: FontWeight.w400,
                  color: getPrimaryTextColor.withOpacity(.3),
                ),
                filled: true,
                fillColor: getColor21,
                prefixIcon: widget.prefixIcon != null
                    ? selectIcon(setldImageIcon(widget.prefixIcon!), width: 15)
                    : null,
                suffixText: widget.suffixText,
                helperText: widget.helperText,
                helperStyle: TextThemeX.text10.copyWith(color: getPrimaryColor),
                suffixStyle:
                    TextThemeX.text17.copyWith(fontWeight: FontWeight.w600),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    width: 1,
                    color: const Color(0xff505050).withOpacity(.33),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    width: 1,
                    color: getPrimaryColor.withOpacity(.67),
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: const BorderSide(
                    width: 1,
                    color: lightRed,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    width: 1,
                    color: lightRed.withOpacity(.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
