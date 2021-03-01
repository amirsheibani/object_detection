import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hive/hive.dart';
import 'package:object_detection/src/global.dart';
import 'package:object_detection/src/pages/home_page.dart';
import 'package:object_detection/src/theme/theme.dart';
import 'package:object_detection/src/theme/theme_notifier.dart';
import 'package:object_detection/src/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  HttpOverrides.global = new MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations( Device.get().isPhone ?
  [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,] :
  [DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]
  ).then((_) async {
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
  });
  SharedPreferences.getInstance().then((prefs) {
    Global.darkMode = prefs.getBool('darkMode') ?? false;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(Global.darkMode ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }
  var routes = <String, WidgetBuilder>{
    Routes.SPLASH: (BuildContext context) => HomePage(),
  };

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      key: key,
      title: 'Empty Project',
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      routes: routes,
    );
  }

}
class Routes {
  static const String SPLASH = "/";
  static const String HOME = "/home";
  static const String SETTING = "/setting";
}