import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_view.dart';
import 'package:fts_mobile/design/common/signup/signup_controller.dart';
import 'package:fts_mobile/design/components/c_flat_button.dart';
import 'package:fts_mobile/design/components/c_header.dart';
import 'package:fts_mobile/design/components/c_text_field.dart';
import 'package:fts_mobile/design/utils/design_utils.dart';
import 'package:fts_mobile/design/utils/validators.dart';
import 'package:fts_mobile/utils/extensions.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CHeader(text: 'Sign Up'),
          GetBuilder<SignUpController>(
            builder: (_) {
              return Expanded(
                child: Form(
                  key: controller.signUpFormKey,
                  child: SingleChildScrollView(
                    physics: defaultPhysics,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CTextField(
                          labelText: 'Government ID',
                          keyboardType: TextInputType.name,
                          // textInputAction: TextInputAction.next,
                          controller: controller.govIdController,
                          validator: AuthValidator.emptyNullValidator,
                        ).only(b: 10),
                        CTextField(
                          readOnly: true,
                          labelText: 'Date of birth',
                          controller: controller.dobController,
                          suffixIcon: GestureDetector(
                            onTap: () => controller.selectDate(context),
                            child: const Icon(Icons.calendar_month),
                          ),
                          validator: AuthValidator.emptyNullValidator,
                        ).only(b: 30),
                        Obx(() {
                          return CFlatButton(
                            text: 'FETCH DETAILS',
                            isLoading: controller.isCreating.value,
                            onPressed: controller.fetchDetails,
                          );
                        }),
                        const SizedBox(height: 40),
                        if (controller.userData == null)
                          const Text('Officer not found.')
                        else ...[
                          KeyValue('Name: ', controller.userData?['name']),
                          KeyValue('Contact Number: ',
                              controller.userData?['contactNumber']),
                          KeyValue('Email: ', controller.userData?['email']),
                          StreamBuilder<DocumentSnapshot>(
                            stream: (controller.userData?['departmentRef']
                                    as DocumentReference)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading");
                              }

                              return KeyValue(
                                  'Citizen Name', snapshot.data?['name']);
                            },
                          ),
                          const SizedBox(height: 15),
                          CFlatButton(
                            text: 'REGISTER REQUEST',
                            onPressed: () {
                              Get.back();
                              "Registration request has been sent to inspector !"
                                  .successSnackbar();
                            },
                          ),
                        ],
                        const SizedBox(height: 50),
                        SizedBox(height: context.bottomPadding),
                      ],
                    ).symmentric(h: horizontalPadding),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
