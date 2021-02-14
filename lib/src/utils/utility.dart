import 'dart:io';
import 'dart:math';


import 'package:flutter/material.dart';
import 'package:object_detection/src/global.dart';
import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

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

class Utility {

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
  static String getImagePathAssets(String name,bool toggle){
    return toggle ? Global.darkMode ? 'assets/images/${name}_l.png' : 'assets/images/${name}_d.png' : Global.darkMode ? 'assets/images/${name}_d.png' : 'assets/images/${name}_l.png';
  }
  static String getImagePathAssetsForAppBar(String name){
    return Global.darkMode ? 'assets/images/${name}_d.png' : 'assets/images/${name}_l.png';
  }
  static double getWidthPercent(BuildContext context,double percent){
    var screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth * percent) / 100;
  }
  static double getHeightPercent(BuildContext context,double percent,){
    var screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight * percent) / 100;
  }
  static String getDifferenceDate(DateTime date){
    var duration = date.difference(DateTime.now());
    String value;
    int d = duration.inDays * -1;
    if(d < 31 && d > 0){
      if(d ~/ 7 > 0){
        value = '${d ~/ 7} week ago';
      }else{
        value = '$d days ago';
      }
    }else if(d > 31){
      value = '${d ~/ 31} months ago';
    }else if(d == 0){
      int h = duration.inHours * -1;
      if(h < 24 && h > 0){
        value = '$h hours ago';
      }else if(h == 0){
        int m = duration.inMinutes * -1;
        value = '$m minute ago';
      }
    }
    return value;
  }
  static writeInSharedPreferences(String key,dynamic) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    switch(dynamic){
      case String:{
        sharedPrefs.setString(key, dynamic);
      }break;
      case bool:{
        sharedPrefs.setBool(key, dynamic);
      }break;
      case int:{
        sharedPrefs.setInt(key, dynamic);
      }break;
      case double:{
        sharedPrefs.setDouble(key, dynamic);
      }
    }
  }
  static dynamic readInSharedPreferences(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return sharedPrefs.getString(key);
  }
  static bool singInValidationItems(String email,String password) => (email.isNotEmpty && password.isNotEmpty);
  static void showToast(BuildContext context,String msg) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
//        action: SnackBarAction(
//            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
  static String getTypeFolder(String extension){
    String folderType;
    switch(extension) {
      case 'avi':
      case 'mkv':
      case 'mov':
      case 'mp4':{
        folderType = 'Movie';
      }
      break;
      case 'mp3':
      case 'mvm':{
        folderType = 'Music';
      }
      break;
      case 'zip':
      case 'rar':{
        folderType = 'Compress';
      }
      break;
      case 'pdf':
      case 'page':
      case 'xlsx':
      case 'xlsm':
      case 'xlsb':
      case 'xltx':
      case 'docm':
      case 'docx':
      case 'dot':
      case 'dotx':
      case 'text':
      case 'txt':
      case 'pptx':
      case 'pptm':
      case 'ppt':{
        folderType = 'Document';
      }
      break;
      case 'download':{
        folderType = 'Temp';
      }
      break;
      default: {
        folderType = 'Data';
      }
      break;
    }
    return folderType;
  }
  static int getTypeFolderId(String extension){
    int folderTypeId;
    switch(extension) {
      case 'avi':
      case 'mkv':
      case 'mov':
      case 'mp4':{
        folderTypeId = 3;
      }
      break;
      case 'mp3':
      case 'mvm':{
        folderTypeId = 4;
      }
      break;
      case 'zip':
      case 'rar':{
        folderTypeId = 5;
      }
      break;
      case 'pdf':
      case 'page':
      case 'xlsx':
      case 'xlsm':
      case 'xlsb':
      case 'xltx':
      case 'docm':
      case 'docx':
      case 'dot':
      case 'dotx':
      case 'text':
      case 'txt':
      case 'pptx':
      case 'pptm':
      case 'ppt':{
        folderTypeId = 2;
      }
      break;
      case 'download':{
        folderTypeId = 6;
      }
      break;
      default: {
        folderTypeId = 1;
      }
      break;
    }
    return folderTypeId;
  }
}

