import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class AppTheme {
  static var fontName = "WorkSans";
  static var fontColorLightTheme = const Color(0xFF313334);
  static var fontColorDarkTheme = Colors.white;

  static TextTheme _buildTextTheme(TextTheme textTheme, Color color) {
    return Device.get().isIos
        ? Device.get().isPhone
        ? textTheme.copyWith(
      //iPhone
      headline1: textTheme.headline1
          .copyWith(fontFamily: fontName, fontSize: 96, color: color),
      headline2: textTheme.headline2
          .copyWith(fontFamily: fontName, fontSize: 58, color: color),
      headline3: textTheme.headline3
          .copyWith(fontFamily: fontName, fontSize: 48, color: color),
      headline4: textTheme.headline4
          .copyWith(fontFamily: fontName, fontSize: 34, color: color),
      headline5: textTheme.headline5
          .copyWith(fontFamily: fontName, fontSize: 24, color: color),
      headline6: textTheme.headline6
          .copyWith(fontFamily: fontName, fontSize: 20, color: color),
      subtitle1: textTheme.subtitle1
          .copyWith(fontFamily: fontName, fontSize: 18, color: color),
      subtitle2: textTheme.subtitle2
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText1: textTheme.bodyText1
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText2: textTheme.bodyText2
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      button: textTheme.button
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      caption: textTheme.caption
          .copyWith(fontFamily: fontName, fontSize: 12, color: color),
      overline: textTheme.overline
          .copyWith(fontFamily: fontName, fontSize: 10, color: color),
    )
        : textTheme.copyWith(
      //iPad
      headline1: textTheme.headline1
          .copyWith(fontFamily: fontName, fontSize: 96, color: color),
      headline2: textTheme.headline2
          .copyWith(fontFamily: fontName, fontSize: 60, color: color),
      headline3: textTheme.headline3
          .copyWith(fontFamily: fontName, fontSize: 48, color: color),
      headline4: textTheme.headline4
          .copyWith(fontFamily: fontName, fontSize: 34, color: color),
      headline5: textTheme.headline5
          .copyWith(fontFamily: fontName, fontSize: 24, color: color),
      headline6: textTheme.headline6
          .copyWith(fontFamily: fontName, fontSize: 20, color: color),
      subtitle1: textTheme.subtitle1
          .copyWith(fontFamily: fontName, fontSize: 18, color: color),
      subtitle2: textTheme.subtitle2
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText1: textTheme.bodyText1
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText2: textTheme.bodyText2
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      button: textTheme.button
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      caption: textTheme.caption
          .copyWith(fontFamily: fontName, fontSize: 12, color: color),
      overline: textTheme.overline
          .copyWith(fontFamily: fontName, fontSize: 10, color: color),
    )
        : Device.get().isPhone
        ? textTheme.copyWith(
      //Android Phone
      headline1: textTheme.headline1
          .copyWith(fontFamily: fontName, fontSize: 32, color: color),
      headline2: textTheme.headline2
          .copyWith(fontFamily: fontName, fontSize: 28, color: color),
      headline3: textTheme.headline3
          .copyWith(fontFamily: fontName, fontSize: 24, color: color),
      headline4: textTheme.headline4
          .copyWith(fontFamily: fontName, fontSize: 20, color: color),
      headline5: textTheme.headline5
          .copyWith(fontFamily: fontName, fontSize: 18, color: color),
      headline6: textTheme.headline6
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      subtitle1: textTheme.subtitle1
          .copyWith(fontFamily: fontName, fontSize: 18, color: color),
      subtitle2: textTheme.subtitle2
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText1: textTheme.bodyText1
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText2: textTheme.bodyText2
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      button: textTheme.button
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      caption: textTheme.caption
          .copyWith(fontFamily: fontName, fontSize: 12, color: color),
      overline: textTheme.overline
          .copyWith(fontFamily: fontName, fontSize: 10, color: color),
    )
        : textTheme.copyWith(
      //Android Tablet
      headline1: textTheme.headline1
          .copyWith(fontFamily: fontName, fontSize: 96, color: color),
      headline2: textTheme.headline2
          .copyWith(fontFamily: fontName, fontSize: 60, color: color),
      headline3: textTheme.headline3
          .copyWith(fontFamily: fontName, fontSize: 48, color: color),
      headline4: textTheme.headline4
          .copyWith(fontFamily: fontName, fontSize: 34, color: color),
      headline5: textTheme.headline5
          .copyWith(fontFamily: fontName, fontSize: 24, color: color),
      headline6: textTheme.headline6
          .copyWith(fontFamily: fontName, fontSize: 20, color: color),
      subtitle1: textTheme.subtitle1
          .copyWith(fontFamily: fontName, fontSize: 18, color: color),
      subtitle2: textTheme.subtitle2
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText1: textTheme.bodyText1
          .copyWith(fontFamily: fontName, fontSize: 16, color: color),
      bodyText2: textTheme.bodyText2
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      button: textTheme.button
          .copyWith(fontFamily: fontName, fontSize: 14, color: color),
      caption: textTheme.caption
          .copyWith(fontFamily: fontName, fontSize: 12, color: color),
      overline: textTheme.overline
          .copyWith(fontFamily: fontName, fontSize: 10, color: color),
    );
  }

  static TabBarTheme _buildTabBarTheme(
      TabBarTheme tabBarTheme, Color labelColor) {
    return tabBarTheme.copyWith(
      labelStyle: Device.get().isPhone
          ? (Device.get().isIos
          ? ( //iPhone
          TextStyle(
              fontFamily: fontName, fontSize: 20, color: labelColor))
          : ( //Android
          TextStyle(
              fontFamily: fontName, fontSize: 30, color: labelColor)))
          : (Device.get().isIos
          ? ( //iPad
          TextStyle(
              fontFamily: fontName, fontSize: 20, color: labelColor))
          : ( //Tablet
          TextStyle(
              fontFamily: fontName, fontSize: 20, color: labelColor))),
      unselectedLabelStyle: Device.get().isPhone
          ? (Device.get().isIos
          ? ( //iPhone
          TextStyle(
              fontFamily: fontName, fontSize: 18, color: labelColor))
          : ( //Android
          TextStyle(
              fontFamily: fontName, fontSize: 30, color: labelColor)))
          : (Device.get().isIos
          ? ( //iPad
          TextStyle(
              fontFamily: fontName, fontSize: 18, color: labelColor))
          : ( //Tablet
          TextStyle(
              fontFamily: fontName, fontSize: 18, color: labelColor))),
      labelColor: labelColor,
    );
  }

  static ThemeData lightTheme() {
    final ThemeData base = ThemeData.light();
    ColorScheme colorScheme = base.colorScheme.copyWith(
        primary: Colors.teal.shade900,
        primaryVariant: Colors.teal.shade900,
        secondary: Colors.teal,
        secondaryVariant: Colors.teal,
        surface: Colors.lightBlueAccent,
        background: const Color(0xFFE5E5E5),
        error: Colors.redAccent,
        brightness: Brightness.light
    );
    return base.copyWith(
      iconTheme: base.iconTheme.copyWith(color: const Color(0xFF164D3F)),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
          selectedItemColor: Colors.teal, unselectedItemColor: const Color(0xFF164D3F)),
      scaffoldBackgroundColor: Colors.white,
      primaryColorLight: Colors.white,
      primaryColorDark: const Color(0xFF313334),
      primaryColor: Colors.white,
      brightness: Brightness.dark,
      backgroundColor: Colors.white,
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.teal,
      bottomAppBarColor: Colors.blueGrey.shade200,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(base.textTheme, fontColorLightTheme),
    );
  }

  static ThemeData darkTheme() {
    final ThemeData base = ThemeData.dark();
    ColorScheme colorScheme = base.colorScheme.copyWith(
        primary: Colors.lightBlueAccent.shade700,
        primaryVariant: Colors.lightBlueAccent.shade700,
        secondary: Colors.lightBlueAccent,
        secondaryVariant: Colors.lightBlueAccent,
        surface: Colors.teal,
        background: const Color(0xFFE5E5E5),
        error: Colors.redAccent,
        brightness: Brightness.dark);
    return base.copyWith(
      iconTheme: base.iconTheme.copyWith(color: Colors.lightBlueAccent.shade700),
      bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
          selectedItemColor: Colors.lightBlueAccent, unselectedItemColor: Colors.lightBlueAccent.shade700),
      scaffoldBackgroundColor: const Color(0xFF313334),
      primaryColorLight: const Color(0xFF313334),
      primaryColorDark: Colors.white,
      primaryColor: Colors.white,
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF313334),
      accentColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.lightBlueAccent,
      bottomAppBarColor: Colors.blueGrey.shade200,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(base.textTheme, fontColorDarkTheme),
    );
  }
}

final darkTheme = AppTheme.darkTheme();
final lightTheme = AppTheme.lightTheme();

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
