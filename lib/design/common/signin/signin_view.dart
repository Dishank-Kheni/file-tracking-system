import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fts_mobile/design/common/signin/signin_controller.dart';
import 'package:fts_mobile/design/components/c_core_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/design/utils/validators.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class SignInView extends GetWidget<SignInController> {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CHeader(text: 'Sign In'),
          Expanded(
            child: Obx(
              () {
                return Column(
                  children: [
                    const SizedBox(height: 70),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: CCoreButton(
                        onPressed: controller.navigateToSingUp,
                        child: Text(
                          'Not Registered ?',
                          textAlign: TextAlign.center,
                          style: TextThemeX.text11.copyWith(
                            color: getPrimaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    if (controller.isOTPSent.value) ...[
                      const SizedBox(height: 20),
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
                        length: 6,
                        appContext: context,
                        keyboardType: TextInputType.number,
                        focusNode: controller.otpFocusNode,
                        animationType: AnimationType.scale,
                        cursorWidth: 1,
                        cursorHeight: 20,
                        hintCharacter: '-',
                        blinkWhenObscuring: true,
                        obscuringWidget:
                            const Icon(CupertinoIcons.circle_fill, size: 14),
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
                ).symmentric(h: horizontalPadding);
              },
            ),
          ),
        ],
      ),
    );
  }
}
