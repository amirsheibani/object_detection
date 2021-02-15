import 'package:camera/camera.dart';
import 'package:intl/intl.dart';
import 'package:object_detection/src/utils/utility.dart';
import 'dart:async';
import 'dart:io';
import 'dart:ui';


import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CameraPage({Key key, this.cameras}) : super(key: key);

  @override
  _CameraPageState createState() {
    return _CameraPageState();
  }
}


class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController controller;
  XFile imageFile;
  double _minAvailableZoom;
  double _maxAvailableZoom;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  int _pointers = 0;
  CameraLensDirection _lensDirection = CameraLensDirection.back;
  bool _showSettingItems = false;
  bool _settingShowImageResolution = false;
  bool _settingShowFlashState = false;
  bool _settingShowGridState = false;
  ResolutionPreset _resolutionPreset = ResolutionPreset.medium;
  FlashMode _flashMode = FlashMode.auto;
  bool _showGrid = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Text(
            'No camera found',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
      );
    } else {
      cameraInit();
    }
    return (imageFile == null)
        ? Material(
      color: Colors.black,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: _cameraPreviewWidget(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _cameraPreviewGridWidget(),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    bottom: false,
                    top: true,
                    left: false,
                    right: false,
                    child: _cameraControlTopWidget(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    bottom: true,
                    top: false,
                    left: false,
                    right: false,
                    child: _cameraControlBottomWidget(),
                  ),
                )
              ],
            ),
          )
        : Stack(
            children: [
              Image.file(
                File(imageFile.path),
                fit: BoxFit.fitWidth,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  bottom: true,
                  top: false,
                  left: false,
                  right: false,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              // File(imageFile.path).delete();
                              // imageFile = null;
                              final directory = await getApplicationDocumentsDirectory();
                              Directory cameraDirectory = Directory('${directory.path}${Platform.pathSeparator}Camera');
                              if(!cameraDirectory.existsSync()){
                                cameraDirectory.createSync(recursive: true);
                              }
                              String filePath = '${cameraDirectory.path}${Platform.pathSeparator}image_${DateFormat('yyyy_MM_dd_hhmmss').format(new DateTime.now())}.jpg';
                              File(imageFile.path).copy(filePath).then((value){
                                Navigator.pop(context,filePath);
                                setState(() {});
                              });
                            },
                            child: Container(
                              child: Text(
                                "Confirm",
                                style: Theme.of(context).textTheme.headline5.apply(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              File(imageFile.path).delete();
                              imageFile = null;
                              setState(() {});
                            },
                            child: Container(
                              child: Text(
                                "Try Again",
                                style: Theme.of(context).textTheme.headline5.apply(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
  }

  Widget _cameraControlBottomWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/back_btn.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: null,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: controller != null && controller.value.isInitialized && !controller.value.isRecordingVideo ? onTakePictureButtonPressed : null,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/capture_photo.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: null,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (controller != null) {
                  for (CameraDescription cameraDescription in widget.cameras) {
                    if (cameraDescription.lensDirection != _lensDirection) {
                      onNewCameraSelected(cameraDescription);
                      break;
                    }
                  }
                }
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/camera_switch.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Camera not found',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.previewSize.height / controller.value.previewSize.width,
        child: Listener(
          onPointerDown: (_) => _pointers++,
          onPointerUp: (_) => _pointers--,
          child: GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            child: CameraPreview(controller),
          ),
        ),
      );
    }
  }

  Widget _cameraControlTopWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showSettingItems = !_showSettingItems;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.settings,
                    color: _showSettingItems ? Colors.amberAccent : Colors.white,
                    size: 36,
                  ),
                ),
              ),
              // Text(
              //   "POS name",
              //   style: Theme.of(context).textTheme.headline6.apply(color: Colors.white),
              // ),
              SizedBox(
                width: 48,
                height: 48,
              ),
            ],
          ),
          _settingItems(),
          _settingItemSelected(),
        ],
      ),
    );
  }

  Widget _cameraPreviewGridWidget() {
    if (_showGrid) {
      return CustomPaint(
        size: controller.value.previewSize,
        painter: GraphCameraPaper(),
      );
    } else {
      return Container();
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    if (_pointers != 2) {
      return;
    }
    _currentScale = (_baseScale * details.scale).clamp(_minAvailableZoom, _maxAvailableZoom);
    await controller.setZoomLevel(_currentScale);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void cameraInit() async {
    CameraDescription _cameraDescription;
    if (controller != null) {
      return;
    } else {
      for (CameraDescription cameraDescription in widget.cameras) {
        if (cameraDescription.lensDirection == CameraLensDirection.back) {
          _cameraDescription = cameraDescription;
          _lensDirection = CameraLensDirection.back;
          break;
        }
      }
    }
    controller = CameraController(
      _cameraDescription,
      _resolutionPreset,
      enableAudio: false,
    );

    try {
      await controller.initialize();
      _maxAvailableZoom = await controller.getMaxZoomLevel();
      _minAvailableZoom = await controller.getMinZoomLevel();
      controller.setFlashMode(_flashMode);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      _resolutionPreset,
      enableAudio: false,
    );

    controller.addListener(() {
      if (controller.value.hasError) {
        AppendLog.log('camera exception',controller.value.errorDescription);
      }
      if (mounted) setState(() {});
    });

    try {
      await controller.initialize();
      _maxAvailableZoom = await controller.getMaxZoomLevel();
      _minAvailableZoom = await controller.getMinZoomLevel();
      _lensDirection = controller.description.lensDirection;

      controller.setFlashMode(_flashMode);
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          // videoController?.dispose();
          // videoController = null;
        });
        if (file != null) {
          AppendLog.log('camera exception','Picture saved to ${file.path}');
        }
      }
    });
  }

  Future<XFile> takePicture() async {
    if (!controller.value.isInitialized) {
      AppendLog.log('camera exception','Error: select a camera first.');
      return null;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await controller.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Widget _settingItemSelected() {
    if (_showSettingItems) {
      if (_settingShowImageResolution) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      _resolutionPreset = ResolutionPreset.low;
                      onNewCameraSelected(controller.description);
                      setState(() {});
                    },
                    child: Text(
                      'Low',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _resolutionPreset == ResolutionPreset.low ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      _resolutionPreset = ResolutionPreset.medium;
                      onNewCameraSelected(controller.description);
                      setState(() {});
                    },
                    child: Text(
                      'Medium',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _resolutionPreset == ResolutionPreset.medium ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      _resolutionPreset = ResolutionPreset.high;
                      onNewCameraSelected(controller.description);
                      setState(() {});
                    },
                    child: Text(
                      'High',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _resolutionPreset == ResolutionPreset.high ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      _resolutionPreset = ResolutionPreset.veryHigh;
                      onNewCameraSelected(controller.description);
                      setState(() {});
                    },
                    child: Text(
                      'VeryHigh',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _resolutionPreset == ResolutionPreset.veryHigh ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      _resolutionPreset = ResolutionPreset.ultraHigh;
                      onNewCameraSelected(controller.description);
                      setState(() {});
                    },
                    child: Text(
                      'UltraHigh',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _resolutionPreset == ResolutionPreset.ultraHigh ? Colors.amberAccent : Colors.white),
                    )),
              ),
            ],
          ),
        );
      } else if (_settingShowFlashState) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (_flashMode != FlashMode.auto) {
                        _flashMode = FlashMode.auto;
                        onNewCameraSelected(controller.description);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Auto',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _flashMode == FlashMode.auto ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (_flashMode != FlashMode.always) {
                        _flashMode = FlashMode.always;
                        onNewCameraSelected(controller.description);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Always',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _flashMode == FlashMode.always ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (_flashMode != FlashMode.off) {
                        _flashMode = FlashMode.off;
                        onNewCameraSelected(controller.description);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Off',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _flashMode == FlashMode.off ? Colors.amberAccent : Colors.white),
                    )),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      if (_flashMode != FlashMode.torch) {
                        _flashMode = FlashMode.torch;
                        onNewCameraSelected(controller.description);
                        setState(() {});
                      }
                    },
                    child: Text(
                      'Torch',
                      style: Theme.of(context).textTheme.bodyText2.apply(color: _flashMode == FlashMode.torch ? Colors.amberAccent : Colors.white),
                    )),
              ),
            ],
          ),
        );
      } else if (_settingShowGridState) {
        setState(() {});
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showGrid = true;
                    setState(() {});
                  },
                  child: Text(
                    'On',
                    style: Theme.of(context).textTheme.headline6.apply(color: _showGrid ? Colors.amberAccent : Colors.white),
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _showGrid = false;
                    setState(() {});
                  },
                  child: Text(
                    'Off',
                    style: Theme.of(context).textTheme.headline6.apply(color: !_showGrid ? Colors.amberAccent : Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  Widget _settingItems() {
    if (_showSettingItems) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _settingShowImageResolution = !_settingShowImageResolution;
                  if (_settingShowImageResolution) {
                    _settingShowFlashState = false;
                    _settingShowGridState = false;
                  }
                  setState(() {});
                },
                child: Icon(
                  Icons.image,
                  color: _settingShowImageResolution ? Colors.amberAccent : Colors.white,
                  size: 32,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _settingShowFlashState = !_settingShowFlashState;
                  if (_settingShowFlashState) {
                    _settingShowImageResolution = false;
                    _settingShowGridState = false;
                  }
                  setState(() {});
                },
                child: Icon(
                  Icons.flash_on,
                  color: _settingShowFlashState ? Colors.amberAccent : Colors.white,
                  size: 32,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  _settingShowGridState = !_settingShowGridState;
                  if (_settingShowGridState) {
                    _settingShowImageResolution = false;
                    _settingShowFlashState = false;
                  }
                  setState(() {});
                },
                child: Icon(
                  Icons.grid_on,
                  color: _settingShowGridState ? Colors.amberAccent : Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  void _showCameraException(CameraException e) {
    AppendLog.log('camera exception', 'Error: ${e.code}\n${e.description}');
  }
}

class GraphCameraPaper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (double row = size.height / 3; row < size.height; row += size.height / 3) {
      var pointStart = Offset(0, row);
      var pointEnd = Offset(size.width, row);
      canvas.drawLine(pointStart, pointEnd, paint);
    }
    for (double column = size.width / 3; column < size.width; column += size.width / 3) {
      var pointStart = Offset(column, 0);
      var pointEnd = Offset(column, size.height);
      canvas.drawLine(pointStart, pointEnd, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
