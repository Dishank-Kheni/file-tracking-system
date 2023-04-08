import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fts_mobile/design/common/signin/signin_controller.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/design/utils/validators.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ISignInView extends GetWidget<SignInController> {
  const ISignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: const [
          Expanded(
            flex: 6,
            child: _Splash(),
          ),
          Expanded(
            flex: 4,
            child: _Login(),
          ),
        ],
      ),
    );
  }
}

class _Login extends GetWidget<SignInController> {
  const _Login({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'LOGIN',
            style: TextThemeX.text26.copyWith(
              color: const Color(0xff1D18FF),
              fontWeight: FontWeight.w600,
              fontFamily: getPoppinsFontFamily,
            ),
          ),
          const SizedBox(height: 50),
          Form(
            key: controller.mobileNumberFormKey,
            child: CTextField(
              labelText: 'Mobile Number',
              keyboardType: TextInputType.number,
              focusNode: controller.mobileFocusNode,
              textInputAction: TextInputAction.done,
              controller: controller.mobileController,
              validator: AuthValidator.phoneValidator,
              suffixIcon: Obx(
                () => controller.isSendingOtp.value
                    ? defaultLoader()
                    : CCoreButton(
                        onPressed: controller.signInWithPhoneNumber,
                        child: Icon(
                          CupertinoIcons.arrow_right_circle,
                          color: getPrimaryColor,
                        ),
                      ),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          const SizedBox(height: 30),
          if (controller.isOTPSent.value) ...[
            Text(
              'Enter Verification Code',
              style: TextThemeX.text20.copyWith(
                color: getColor12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Enter the otp sent on your number \n${controller.mobileController.text}',
              textAlign: TextAlign.center,
              style: TextThemeX.text10.copyWith(
                color: getPrimaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            PinCodeTextField(
              length: controller.isOTPSent.value ? 6 : 6,
              appContext: context,
              keyboardType: TextInputType.number,
              focusNode: controller.otpFocusNode,
              animationType: AnimationType.scale,
              cursorWidth: 1,
              cursorHeight: 20,
              hintCharacter: '-',
              blinkWhenObscuring: true,
              obscuringWidget: const Icon(CupertinoIcons.circle_fill, size: 14),
              obscureText: true,
              pinTheme: PinTheme(
                activeColor: greenColor,
                inactiveColor: getColor3.withOpacity(.5),
                errorBorderColor: redColor,
                selectedColor: getPrimaryColor,
                borderWidth: 1,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 50,
                activeFillColor: getColor21,
                inactiveFillColor: getColor21,
                selectedFillColor: getColor21,
              ),
              errorAnimationController: controller.otpErrorController,
              controller: controller.otpController,
              onCompleted: controller.verifyOTP,
              onChanged: (_) {},
            ),
          ],
        ],
      ).symmentric(h: 30),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        selectImage(AppImages.webSplash, fit: BoxFit.fill),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectImage(setldImageIcon(AppImages.logo), height: 100),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'FILE',
                  style: TextThemeX.text64.copyWith(
                    color: getColor21,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                    fontFamily: getPoppinsFontFamily,
                  ),
                ),
                Text(
                  'TRACKER',
                  style: TextThemeX.text26.copyWith(
                    color: getColor21,
                    height: 0.1,
                    fontWeight: FontWeight.w600,
                    fontFamily: getPoppinsFontFamily,
                  ),
                ),
              ],
            ).only(b: 30),
          ],
        ),
      ],
    );
  }
}
