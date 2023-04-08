import 'package:flutter/material.dart';
import 'package:fts_mobile/design/common/splash/splash_controller.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class SplashView extends GetWidget<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectImage(
              setldImageIcon(AppImages.logo),
              height: 170,
            ),
            Text(
              'FILE',
              style: TextThemeX.text64.copyWith(
                color: getPrimaryColor,
                fontWeight: FontWeight.w600,
                fontFamily: getOswaldFontFamily,
              ),
            ),
            Text(
              'TRACKER',
              style: TextThemeX.text26.copyWith(
                color: getPrimaryColor,
                height: 0.4,
                fontWeight: FontWeight.w600,
                fontFamily: getOswaldFontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
