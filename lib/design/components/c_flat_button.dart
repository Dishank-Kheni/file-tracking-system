import 'package:flutter/cupertino.dart';

import '/design/components/c_core_button.dart';
import '/design/utils/design_utils.dart';
import '/utils/extensions.dart';

class CFlatButton extends StatelessWidget {
  final String text;
  final String? icon;
  final double width;
  final double height;
  final Color? bgColor;
  final Color? textColor;
  final Color? loaderColor;
  final bool isLoading;
  final bool isDisabled;
  final bool showShadow;
  final EdgeInsets padding;
  final void Function()? onPressed;
  const CFlatButton({
    Key? key,
    this.icon,
    this.bgColor,
    this.textColor,
    this.onPressed,
    this.loaderColor,
    required this.text,
    this.showShadow = true,
    this.isLoading = false,
    this.isDisabled = false,
    this.width = double.infinity,
    this.height = flatButtonHeight,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CCoreButton(
      onPressed: isLoading ? null : onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: isDisabled || onPressed == null ? 0.5 : 1,
        child: Container(
          width: width,
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor ?? getPrimaryColor,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: showShadow ? boxShadow2 : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null && !isLoading)
                selectIcon(setldImageIcon(icon!)).only(r: 8),
              isLoading
                  ? defaultLoader(color: loaderColor ?? getColor21)
                  : Text(
                      text,
                      style: TextThemeX.text13.copyWith(
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600,
                        fontFamily: getPoppinsFontFamily,
                        color: textColor ?? setColor(getColor21),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
