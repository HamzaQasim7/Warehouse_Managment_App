import 'package:second_opinion_app/ui/home/home.dart';
import 'package:second_opinion_app/ui/login/login.dart';
import 'package:second_opinion_app/ui/mode/mode.dart';
import 'package:second_opinion_app/ui/splash/splash.dart';
import 'package:flutter/material.dart';

import '../../ui/login/auth.dart';
import '../../ui/page_view/driver_page_view.dart';
import '../../ui/page_view/home_page_view.dart';
import '../../ui/page_view/picker_page_view.dart';
import '../../ui/page_view/receiver_page_view.dart';

class Routes {
  Routes._();

  //static variables
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String pageView = '/pageView';
  static const String driverPageView = '/driverPageView';
  static const String receiverPageView = '/receiverPageView';
  static const String pickerPageView = '/pickerPageView';
  static const String modeSelection = '/modeSelection';
  static const String auth = '/auth';

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => SplashScreen(),
    login: (BuildContext context) => LoginScreen(),
    home: (BuildContext context) => HomeScreen(),
    pageView: (BuildContext context) => PageViewScreen(),
    driverPageView: (BuildContext context) => DriverPageViewScreen(),
    receiverPageView: (BuildContext context) => ReceiverPageViewScreen(),
    modeSelection: (BuildContext context) => ModeSelectionScreen(),
    pickerPageView: (BuildContext context) => PickerPageViewScreen(),
    auth: (BuildContext context) => AuthScreen(),
  };
}
