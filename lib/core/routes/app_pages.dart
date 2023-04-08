// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:fts_mobile/core/services/gs_services.dart';
import 'package:fts_mobile/design/citizen/c_home_controller.dart';
import 'package:fts_mobile/design/citizen/c_home_view.dart';
import 'package:fts_mobile/design/citizen/c_message_controller.dart';
import 'package:fts_mobile/design/citizen/c_message_view.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_controller.dart';
import 'package:fts_mobile/design/clerk-officer/co_home_view.dart';
import 'package:fts_mobile/design/clerk-officer/create-file/create_file_controller.dart';
import 'package:fts_mobile/design/clerk-officer/create-file/create_file_view.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scan_file_controller.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scan_file_view.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scanner_controller.dart';
import 'package:fts_mobile/design/clerk-officer/scan-file/scanner_view.dart';
import 'package:fts_mobile/design/common/signin/signin_controller.dart';
import 'package:fts_mobile/design/common/signin/signin_view.dart';
import 'package:fts_mobile/design/common/signup/signup_controller.dart';
import 'package:fts_mobile/design/common/signup/signup_view.dart';
import 'package:fts_mobile/design/common/splash/splash_controller.dart';
import 'package:fts_mobile/design/common/splash/splash_view.dart';
import 'package:fts_mobile/design/common/unknown_404_view.dart';
import 'package:fts_mobile/design/inspector/i-home/i_home_controller.dart';
import 'package:fts_mobile/design/inspector/i-home/i_home_view.dart';
import 'package:fts_mobile/design/inspector/i-signin/i_signin_view.dart';
import 'package:get/get_navigation/src/nav2/get_nav_config.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/instance_manager.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final unknownRoute = GetPage(
    name: _Paths.UNKNOWN_404,
    page: () => const Unknown404View(),
  );

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: BindingsX._splashBindings(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SignInView(),
      binding: BindingsX._signInBindings(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => const SignUpView(),
      binding: BindingsX._signUpBindings(),
    ),
    // Citizen
    GetPage(
      name: _Paths.CHOME,
      page: () => const CHomeView(),
      binding: BindingsX._CHomeBindings(),
      children: [
        GetPage(
          name: _Paths.CMESSAGE,
          page: () => const CMessageView(),
          binding: BindingsX._CMessageBindings(),
        ),
      ],
    ),
    // Clerk
    GetPage(
      name: _Paths.COHOME,
      page: () => const COHomeView(),
      binding: BindingsX._COHomeBindings(),
      children: [
        GetPage(
          name: _Paths.CREATEFILE,
          page: () => const CreateFileView(),
          binding: BindingsX._createFileBindings(),
          children: [
            GetPage(
              name: _Paths.SCANNER,
              page: () => const ScannerView(),
              binding: BindingsX._scannerBindings(),
            ),
          ],
        ),
        GetPage(
          name: _Paths.SCANFILE,
          page: () => const ScanFileView(),
          binding: BindingsX._scanFileBindings(),
          children: [
            GetPage(
              name: _Paths.SCANNER,
              page: () => const ScannerView(),
              binding: BindingsX._scannerBindings(),
            ),
          ],
        ),
      ],
    ),
    // Inspector
    GetPage(
      name: _Paths.ISIGNIN,
      page: () => const ISignInView(),
      binding: BindingsX._ISignInBindings(),
    ),
    GetPage(
      name: _Paths.IHOME,
      page: () => const IHomeView(),
      binding: BindingsX._IHomeBindings(),
      middlewares: [WebAuthMiddleWare()],
    ),
  ];
}

class BindingsX {
  static BindingsBuilder initialBindigs() {
    return BindingsBuilder(() {});
  }

  static BindingsBuilder<dynamic> _signInBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<SignInController>(
        () => SignInController(),
      );
    });
  }

  // ignore: non_constant_identifier_names
  static BindingsBuilder<dynamic> _COHomeBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<COHomeController>(
        () => COHomeController(),
      );
    });
  }

  static BindingsBuilder<dynamic> _splashBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<SplashController>(
        () => SplashController(),
      );
    });
  }

  static BindingsBuilder<dynamic> _signUpBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<SignUpController>(
        () => SignUpController(),
      );
    });
  }

  static BindingsBuilder<dynamic> _createFileBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<CreateFileController>(
        () => CreateFileController(),
      );
    });
  }

  static BindingsBuilder<dynamic> _scanFileBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<ScanFileController>(
        () => ScanFileController(),
      );
    });
  }

  static BindingsBuilder<dynamic> _scannerBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<ScannerController>(
        () => ScannerController(),
      );
    });
  }

  // ignore: non_constant_identifier_names
  static BindingsBuilder<dynamic> _CHomeBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<CHomeController>(
        () => CHomeController(),
      );
    });
  }

  // ignore: non_constant_identifier_names
  static BindingsBuilder<dynamic> _CMessageBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<CMessageController>(
        () => CMessageController(),
      );
    });
  }

  // ignore: non_constant_identifier_names
  static BindingsBuilder<dynamic> _ISignInBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<SignInController>(
        () => SignInController(),
      );
    });
  }

  // ignore: non_constant_identifier_names
  static BindingsBuilder<dynamic> _IHomeBindings() {
    return BindingsBuilder(() {
      Get.lazyPut<IHomeController>(
        () => IHomeController(),
      );
    });
  }
}

class WebAuthMiddleWare implements GetMiddleware {
  @override
  int? priority;
  WebAuthMiddleWare({this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (route == Routes.IHOME && GSServices.getCurrentUserData() == null) {
      return const RouteSettings(name: Routes.ISIGNIN);
    }
    return null;
  }

  @override
  GetPage? onPageCalled(GetPage? page) => page;

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) => bindings;

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  @override
  Widget onPageBuilt(Widget page) => page;

  @override
  void onPageDispose() {}

  @override
  Future<GetNavConfig?> redirectDelegate(GetNavConfig route) =>
      SynchronousFuture(route);
}
