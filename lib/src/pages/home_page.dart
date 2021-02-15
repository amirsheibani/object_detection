
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:object_detection/src/blocs/my_bloc.dart';
import 'package:object_detection/src/pages/camera_page.dart';
import 'package:object_detection/src/pages/setting.dart';
import 'package:object_detection/src/pages/tflite_page.dart';
import 'package:object_detection/src/utils/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool permissionStatus = true;
  List<PlatformFile> _paths = List();
  String _extension;
  FileType pickingType = FileType.image;
  bool multiPick = true;

  MyBloc _myBloc = MyBloc();
  Stream _myPreviousStream;

  @override
  void initState() {
    _getAllImage();
    if (_myBloc.myControllerStream != _myPreviousStream) {
      _myPreviousStream = _myBloc.myControllerStream;
      _listen(_myPreviousStream);
    }
    super.initState();
  }

  void _listen(Stream<dynamic> stream) {
    stream.listen((value) async {
      if (value != null) {
        if (value is int) {
          setState(() {
            print(value);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _permissionHandler(context);
    return Device
        .get()
        .isPhone ? _smartPhoneLayout(context) : (Device.width > Device.height ? _tabletLandscapeLayout(context) : _tabletPortraitLayout(context));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _smartPhoneLayout(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        key: _scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 0.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      height: Utility.getWidthPercent(context, 10),
                      width: Utility.getWidthPercent(context, 75),
                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            _openFileExplorer();
                          },
                          child: Center(
                            child: Text(
                              "Select from device",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _takeImage(),
                ],
              ),
            ),
            Expanded(child: _imageSelected())
          ],
        ),
    );
  }

  Widget _tabletLandscapeLayout(BuildContext context) {
    return _smartPhoneLayout(context);
  }

  Widget _tabletPortraitLayout(BuildContext context) {
    return _smartPhoneLayout(context);
  }

  Widget _appBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      elevation: 0.0,
      title: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _goToSettingPage();
                  },
                  child: SizedBox(
                    height: AppBar().preferredSize.height,
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          size: 28,
                          color: Theme
                              .of(context)
                              .iconTheme
                              .color,
                        ),
                        // Text("Back",style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ),
              ),
              // Image.asset(Utility.getImagePathAssetsForAppBar('logo'),
              //     height: (Device
              //         .get()
              //         .isPhone) ? (AppBar().preferredSize.height * 33) / 100 : (AppBar().preferredSize.height * 60) / 100, fit: BoxFit.cover),
              SizedBox(
                height: AppBar().preferredSize.height,
                width: 80,
              ),
            ],
          );
        },
      ),
    );
  }

  void _goToTFLitePage(String path) {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset(0.0, 0.0);
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: TFLitePage(path),
            // child: Padding(
            //   padding: EdgeInsets.only(top: ((MediaQuery.of(context).size.height - AppBar().preferredSize.height - 47) / 4)),
            //   child: TFLitePage(path),
            // ),
          );
        });
  }

  void _goToSettingPage() {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.black26,
        barrierDismissible: false,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset(0.0, 0.0);
          var curve = Curves.ease;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height - AppBar().preferredSize.height - 47) / 2),
              child: SettingPage(),
            ),
          );
        });
  }

  Widget _imageSelected(){
    return GridView.builder(
        itemCount: _paths.length,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              _goToTFLitePage(_paths[index].path);
            },
            onLongPress: (){
              if(_paths[index].path.contains("Camera")){
                File(_paths[index].path).deleteSync();
              }
              _paths.removeAt(index);
              setState(() {});
            },
            child: Card(
              child: GridTile(
                footer: Text(_paths[index].name, style: Theme
                    .of(context)
                    .textTheme
                    .bodyText2
                    .apply(color: Colors.white),),
                child: Image.file(
                  File(_paths[index].path),
                  fit: BoxFit.fitWidth,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ), //just for testing, will fill with image later
              ),
            ),
          );
        }
    );
  }
  Widget _takeImage(){
    if(pickingType == FileType.image){
      return Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Container(
          height: Utility.getWidthPercent(context, 10),
          width: Utility.getWidthPercent(context, 75),
          decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              highlightColor: Colors.transparent,
              onTap: () async {
                _goToCamera();
              },
              child: Center(
                child: Text(
                  "Take image",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ),
        ),
      );
    }else{
      return Container();
    }
  }
  _openFileExplorer() async {
    try {
      FilePicker.platform.pickFiles(
        type: pickingType,
        allowMultiple: multiPick,
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '')?.split(',') : null,
      ).then((value){
        if(value.files != null){
          setState(() {
            _paths.addAll(value.files);
          });
        }
      });
    } on PlatformException catch (e) {
      AppendLog.log('Platform Exception','Unsupported operation' + e.toString());
    } catch (ex) {
      AppendLog.log('Exception', ex.toString());
    }
    if (!mounted) return;
  }
  _goToCamera() async {
    try {
      var camera =  await availableCameras();
      if(camera.isEmpty){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Camera is not available'),
          ),
        );
      }else{
        String filePath = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(cameras: camera,),
          ),
        );
        if(filePath != null){
          _paths.add(PlatformFile(path: filePath,name: path.basename(filePath)));
          setState(() {});
        }
      }
    } catch (e) {
      print(e);
    }
  }
  _permissionHandler(BuildContext context) async {
    if(permissionStatus){
      permissionStatus = false;
      if (await Permission.location.status != PermissionStatus.granted) {
        await Permission.location.request();
      }
      if (await Permission.camera.status != PermissionStatus.granted) {
        await Permission.camera.request();
      }
      // if (await Permission.storage.status != PermissionStatus.granted) {
      //   await Permission.storage.request();
      // }
      // if (await Permission.mediaLibrary.status != PermissionStatus.granted) {
      //   await Permission.mediaLibrary.request();
      // }
      // if (await Permission.photos.status != PermissionStatus.granted) {
      //   await Permission.photos.request();
      // }
      // if (await Permission.sensors != PermissionStatus.granted) {
      //   await Permission.camera.request();
      // }
    }

  }
 _getAllImage() async {
   Directory documentsDirectory = await getApplicationDocumentsDirectory();
   String cameraDirectoryPath = '${documentsDirectory.path}${Platform.pathSeparator}Camera';
   var files = <FileSystemEntity>[];
   Directory cameraDirectory = Directory(cameraDirectoryPath);
   files = cameraDirectory.listSync(recursive: false);
   files.forEach((element) {
     _paths.add(PlatformFile(path: element.path,name: path.basename(element.path)));
   });
   setState(() {});
 }
}