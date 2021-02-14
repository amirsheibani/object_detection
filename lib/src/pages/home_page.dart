
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:object_detection/src/blocs/my_bloc.dart';
import 'package:object_detection/src/utils/utility.dart';

class HomePage extends StatefulWidget {
  // final MyFileManager fileManager;
  //
  // HomePage(this.fileManager);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyBloc _myBloc = MyBloc();
  Stream _myPreviousStream;

  @override
  void initState() {
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
        body:Container()
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
                    _goToNextPage();
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
              Image.asset(Utility.getImagePathAssetsForAppBar('logo'),
                  height: (Device
                      .get()
                      .isPhone) ? (AppBar().preferredSize.height * 33) / 100 : (AppBar().preferredSize.height * 60) / 100, fit: BoxFit.cover),
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

  void _backToPreviousPage(BuildContext context) {
    Navigator.pop(context);
  }

  void _goToNextPage() {
    Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation) {
            // return NextPage();
            return;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        ));
  }
}