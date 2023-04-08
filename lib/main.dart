import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fts_mobile/core/routes/app_pages.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/core/services/messaging_service.dart';
import 'package:fts_mobile/design/components/unfocus_wrapper.dart';
import 'package:fts_mobile/design/utils/app_theme.dart';
import 'package:fts_mobile/firebase_options.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GSServices.initialize();
  if (!kIsWeb) {
    await MessagingService().requestPushNotification();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnFocusWrapper(
      child: GetMaterialApp(
        title: 'File Tracker',
        builder: (context, _) {
          return ResponsiveWrapper.builder(
            _,
            // maxWidth: 430,
            defaultScale: true,
            minWidth: kIsWeb ? 1200 : 375,
          );
        },
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
            scrollbars: false, physics: const BouncingScrollPhysics()),
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        unknownRoute: AppPages.unknownRoute,
        defaultTransition:
            kIsWeb ? Transition.circularReveal : Transition.cupertino,
        initialBinding: BindingsX.initialBindigs(),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }
}
