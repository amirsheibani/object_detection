import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:object_detection/src/model/result.dart';
import 'package:object_detection/src/theme/theme.dart';
import 'package:object_detection/src/utils/tflite.dart';
import 'package:object_detection/src/utils/utility.dart';
import 'package:tflite/tflite.dart';

class TFLitePage extends StatefulWidget {
  final imagePath;

  TFLitePage(this.imagePath);

  @override
  _TFLitePageState createState() => _TFLitePageState();
}

class _TFLitePageState extends State<TFLitePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  double _imageWidth;
  double _imageHeight;
  Size _screenSize;
  List<Widget> _stackChildren = [];
  bool isImageLoad = false;

  List<Result> outputs;

  @override
  void dispose() {
    TFLiteObject.disposeModel();
    super.dispose();
  }

  void initState() {
    super.initState();
    FileImage(File(widget.imagePath))
        .resolve(ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
      _imageWidth = info.image.width.toDouble();
      _imageHeight = info.image.height.toDouble();
      // _image = File(widget.imagePath);
      loadModel();
    })));
  }

  loadModel() {
    Tflite.close();
    try {
      Tflite.loadModel(
        model: "assets/ml/detect.tflite",
        labels: "assets/ml/labelmap.txt",
      ).then((value) {
        if (value == 'success') {
          predictImage(File(widget.imagePath));
        } else {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text("Can't load model"),
            ),
          );
        }
      });
    } on PlatformException {
      print("Failed to load the model");
    }
  }

  Future<List> ssdMobileNet(File image) async {
    return await Tflite.detectObjectOnImage(path: image.path, numResultsPerClass: 1);

    // setState(() {
    //   _recognitions = recognitions;
    // });
  }

  predictImage(File image) async {
    if (image == null) return;
    ssdMobileNet(image).then((recognitions) {
      setState(() {
        _stackChildren.addAll(renderBoxes(_screenSize, recognitions));
      });
    });
  }

  List<Widget> renderBoxes(Size screen, List recognitions) {
    if (recognitions == null) return [];
    if (_imageWidth == null || _imageHeight == null) return [];

    // double factorX = _screenSize.width;
    double factorX = _screenSize.width;
    double factorY = _screenSize.width;
    // double factorW = _screenSize.width;
    // double factorH = _screenSize.height;

    Color blue = Colors.white;

    return recognitions.map((re) {
      if(re["confidenceInClass"] > 0.60){
        print('name :${re["detectedClass"]} confidenceInClass :${re["confidenceInClass"]}  x :${re["rect"]["x"]} y :${re["rect"]["y"]} w :${re["rect"]["w"]} h :${re["rect"]["h"]} factorX :$factorX factorY :$factorY ' );
      }

      return Positioned(
          left: (re["rect"]["x"]) * factorX ,
          top: (re["rect"]["y"]) * factorY,
          width: re["rect"]["w"] * factorX,
          height: re["rect"]["h"] * factorY,
          child: ((re["confidenceInClass"] > 0.60)) ? Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: blue,
                  width: 3,
                )),
            child: Text(
              "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                background: Paint()
                  ..color = blue,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ) : Container()
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return (Device
        .get()
        .isPhone) ? _smartPhoneLayout() : (Device.width > Device.height ? _tabletLandscapeLayout() : _tabletPortraitLayout());
  }

  Widget _smartPhoneLayout() {
    _screenSize = MediaQuery
        .of(context)
        .size;
    if (!isImageLoad) {
      isImageLoad = true;
      _stackChildren.add(Positioned(
        top: 0.0,
        left: 0.0,
        width: _screenSize.width,
        child: Image.file(File(widget.imagePath)),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: _appBar(context)),
            Expanded(
              flex: 8,
              child: Stack(
                children:
                _stackChildren,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _tabletLandscapeLayout() {
    return _smartPhoneLayout();
  }

  Widget _tabletPortraitLayout() {
    return _smartPhoneLayout();
  }

  Widget _appBar(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: ColorsBox.ColorsBoxItems[ColorsBoxType.dialog_title_background],
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Column contents horizontally,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _backToHomePage();
                    },
                    child: SizedBox(
                      height: AppBar().preferredSize.height,
                      // width: 80,
                      child: Center(
                        child: Text(
                          "Close",
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline6
                              .apply(color: ColorsBox.ColorsBoxItems[ColorsBoxType.dialog_title_close_text]),
                        ),
                      )
                    ),
                  ),
                ),
                SizedBox(
                  height: AppBar().preferredSize.height,
                  width: 80,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _backToHomePage();
                    },
                    child: SizedBox(
                        height: AppBar().preferredSize.height,
                        // width: 80,
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6
                                .copyWith(fontWeight: FontWeight.bold)
                                .apply(color: ColorsBox.ColorsBoxItems[ColorsBoxType.dialog_title_confirm_text])
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _backToHomePage() {
    Navigator.pop(context);
  }
}