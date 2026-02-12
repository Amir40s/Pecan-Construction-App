import 'package:get/get.dart';
import 'package:pecan_construction/config/bindings/assignEmployeBinding.dart';
import 'package:pecan_construction/config/bindings/notification_binding.dart';
import 'package:pecan_construction/config/bindings/role_binding.dart';
import 'package:pecan_construction/config/routes/routes_name.dart';
import 'package:pecan_construction/screens/auth_screens/controllers/role_controllers.dart';
import 'package:pecan_construction/screens/auth_screens/forget_password_screens.dart';
import 'package:pecan_construction/screens/auth_screens/signin_screen.dart';
import 'package:pecan_construction/screens/auth_screens/signup_screens.dart';
import 'package:pecan_construction/screens/auth_screens/splash_screens.dart';

import '../../screens/admin_screens/add_ataichment_screen.dart';
import '../../screens/admin_screens/assign_employe_screen.dart';
import '../../screens/admin_screens/bottom_nav_screen.dart';
import '../../screens/admin_screens/create_site_screen.dart';
import '../../screens/admin_screens/setting_screens.dart';
import '../../screens/admin_screens/site_details_screen.dart';
import '../../screens/auth_screens/role_selection_screen.dart';
import '../bindings/add_attaichment_binding.dart';
import '../bindings/app_bindings.dart';

class AppRoutes {

  static final routes = [
    GetPage(name: RoutesName.splash,
        page:() =>  SplashScreen()),
    GetPage(name: RoutesName.login,
        page:() =>  SigninScreen()),
    GetPage(name: RoutesName.signup,
        page:() =>  SignUpScreens()),
    GetPage(name: RoutesName.forgotPassword,
        page:() =>  ForgetPasswordScreens()),
    GetPage(name: RoutesName.BottomNavScreen,
        page:() =>  BottomNavScreen(),
    binding: NotificationBinding()),
    GetPage(name: RoutesName.CreateSiteScreen,
        page:() =>  CreateSiteScreen(),
        binding: createSiteControllerBinding()),
    GetPage(name: RoutesName.AssignEmployeeScreen,
        page:() =>  AssignEmployeeScreen(),
      binding: AssignEmployeeBinding()
    ),
    GetPage(name: RoutesName.AddAttachmentScreen,
        page:() =>  AddAttachmentScreen(),
        binding: AddAttachmentbinding()
    ),
    GetPage(name: RoutesName.SiteDetailsScreen,
        page:() =>  SiteDetailsScreen(),
    ),
    GetPage(name: RoutesName.SettingsScreen,
      page:() =>  SettingsScreen(),
    ),
    GetPage(name: RoutesName.RoleSelectionScreen,
      page:() =>  RoleSelectionScreen(),
      binding: RoleSelectionBinding(),
    ),
  ];
}