import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:object_detection/src/model/result.dart';
import 'package:object_detection/src/utils/utility.dart';
import 'package:tflite/tflite.dart';

class TFLiteObject {

  static StreamController<List<Result>> tfLiteResultsController = new StreamController.broadcast();
  static List<Result> _outputs = List();
  static var modelLoaded = false;

  static Future<String> loadModel() async{
    Tflite.close();
    try {
      await Tflite.loadModel(
        model: "assets/tflite/ssd_mobilenet.tflite",
        labels: "assets/tflite/ssd_mobilenet.txt",
      );
    } on PlatformException {
      print("Failed to load the model");
    }
  }




  static classifyImage(CameraImage image) async {

    await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        numResults: 5)
        .then((value) {
      if (value.isNotEmpty) {
        AppendLog.log("classifyImage", "Results loaded. ${value.length}");

        //Clear previous results
        _outputs.clear();

        value.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));

          AppendLog.log("classifyImage",
              "${element['confidence']} , ${element['index']}, ${element['label']}");
        });
      }

      //Sort results according to most confidence
      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));

      //Send results
      tfLiteResultsController.add(_outputs);
    });
  }
  static classifyImagePath(String  imagePath) async {

    await Tflite.runModelOnImage(path: imagePath).then((value) {
      if(value.isNotEmpty){
        _outputs.clear();
        value.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));

          print("classifyImage ${element['confidence']} , ${element['index']}, ${element['label']}");
        });
      }
      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));
      tfLiteResultsController.add(_outputs);
    });
  }
  static void disposeModel(){
    Tflite.close();
    tfLiteResultsController.close();
  }
}