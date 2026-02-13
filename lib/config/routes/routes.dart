import 'package:get/get.dart';
import 'package:pecan_construction/config/bindings/EmployeeSiteBinding.dart';
import 'package:pecan_construction/config/bindings/assignEmployeBinding.dart';
import 'package:pecan_construction/config/bindings/employ_bottom_navBindings.dart';
import 'package:pecan_construction/config/bindings/employee_notificationBinding.dart';
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
import '../../screens/employ_screens/bottom_nav_screen.dart';
import '../../screens/employ_screens/employ_home_screens.dart';
import '../../screens/employ_screens/employe_notification_screen.dart';
import '../../screens/employ_screens/employee_attaichment_screen.dart';
import '../../screens/employ_screens/employee_setting_screen.dart';
import '../../screens/employ_screens/employee_site_details.dart';
import '../../screens/employ_screens/employee_site_screen.dart';
import '../bindings/add_attaichment_binding.dart';
import '../bindings/app_bindings.dart';
import '../bindings/employ_attaichmentBinding.dart';
import '../bindings/employee_home_binding.dart';
import '../bindings/employee_site_details_binding.dart';

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
    GetPage(name: RoutesName.EmployeeBottomNavScreen,
      page:() =>  EmployeeBottomNavScreen(),
      binding: EmployeeBottomBinding(),
    ),
    GetPage(name: RoutesName.EmployeeHomeScreen,
      page:() =>  EmployHomeScreens(),
      binding: EmployeeHomeBinding(),
    ),
    GetPage(name: RoutesName.EmployeeSitesScreen,
      page:() =>  EmployeeSitesScreen(),
      binding: EmployeeSiteBinding(),
    ),
    GetPage(name: RoutesName.AttachmentsScreen,
      page:() =>  AttachmentsScreen(),
      binding: AttachmentsBinding(),
    ),
    GetPage(name: RoutesName.EmployeeSiteDetailsScreen,
      page:() =>  EmployeeSiteDetailsScreen(),
      binding: EmployeeSiteDetailsBinding()
    ),
    GetPage(name: RoutesName.EmployeeSettingScreen,
        page:() =>  EmployeeSettingScreen(),
    ),
    GetPage(name: RoutesName.EmployeNotificationScreen,
      page:() =>  EmployeNotificationScreen(),
      binding: EmployeeNotificationBinding()
    ),
  ];
}