import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scan_file_controller.dart';
import 'package:fts_mobile/design/components/c_flat_button.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/design/utils/validators.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ShowSendMessage extends GetWidget<ScanFileController> {
  const ShowSendMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Request Additional Documents",
            style: TextThemeX.text14,
          ).only(b: 20),
          CTextField(
            labelText: 'Message',
            controller: controller.messageController,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            validator: AuthValidator.emptyNullValidator,
          ).only(b: 15),
          Obx(
            () => Row(
              children: [
                Text(
                  'Urgent ?',
                  style: TextThemeX.text14,
                ),
                const Spacer(),
                Transform.scale(
                  scale: .8,
                  transformHitTests: false,
                  child: CupertinoSwitch(
                    activeColor: orangeColor,
                    value: controller.isUrgent.value,
                    onChanged: (value) {
                      controller.isUrgent.value = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CFlatButton(
            height: 50,
            text: 'SEND',
            bgColor: greenColor,
            onPressed: controller.sendMessage,
          ),
        ],
      ).only(
        l: 20,
        r: 20,
        t: 15,
        b: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
    );
  }
}
