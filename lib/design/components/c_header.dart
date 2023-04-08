import 'package:flutter/cupertino.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/route_manager.dart';

class CHeader extends StatelessWidget {
  final String? text;
  final Widget? child;
  const CHeader({Key? key, this.text, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: Platform.isIOS ? 110 : 90,
      height: 90,
      color: getPrimaryColor,
      padding: EdgeInsets.only(top: context.statusBarHeight),
      child: child ??
          Row(
            children: [
              if (navigator?.canPop() ?? false) ...[
                CCoreButton(
                  onPressed: () => Get.back(),
                  child: Icon(
                    CupertinoIcons.chevron_left_circle,
                    color: getColor21,
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                text ?? '',
                style: TextThemeX.text20.copyWith(color: getColor21),
              ),
            ],
          ).symmentric(h: horizontalPadding),
    );
  }
}
