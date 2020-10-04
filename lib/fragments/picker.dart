import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as IMG;
import 'dart:io' as IO;
import 'package:path_provider/path_provider.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  var modelLoaded = false;
  bool _busy = false;
  var _imbyte = null;
  String _tempDir;

  static Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/animeWho.tflite",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  pickImageFromGallery() async {
    setState(() {
      _busy = true;
    });
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxHeight: 256, maxWidth: 256);
    if (image == null) return;
    // IMG.Image im = IMG.decodeImage(new IO.File(image.path).readAsBytesSync());
    // IMG.Image im2 = IMG.copyResize(im, height: 256, width: 256);
    // new IO.File(_tempDir).writeAsBytesSync(IMG.encodePng(im2));
    // print("Temporary Image Saved");
    // runModel(im2.getBytes());
    // runModel(_tempDir);
    runModel(image.path);
    // setState(() {
    //   _imbyte = IO.File(image.path).readAsBytesSync();
    // });
    // print(image);
    // print(im2.getBytes());
    print("Running on: " + image.path);
  }

  void runModel(var image) async {
    try {
      await Tflite.runPix2PixOnImage(
        path: image,
        imageStd: 255,
        asynch: true,
        imageMean: 0,
        outputType: "png",
      ).then((value) {
        print("Image Generated");

        setState(() {
          // var _im2 = IMG.grayscale(_im);
          _imbyte = value;
        });
        print(_imbyte);
      });
    } catch (e) {
      print("ERROR CUSTOM :" + e);
    }
    await Tflite.close();

    setState(() {
      _busy = false;
    });
    print("Model Closed");
    // try {
    //   IO.File(_tempDir).deleteSync();
    //   print("Temporary Image Deleted");
    // } catch (e) {
    //   print("Error ON IO: " + e);
    // }
  }

  // void getDirSet() async {
  //   IO.Directory dir = await getTemporaryDirectory();
  //   setState(() {
  //     _tempDir = dir.path + "/temp.png";
  //   });
  //   print("tempDir set to: " + _tempDir);
  // }

  void initState() {
    super.initState();
    setState(() {
      _busy = true;
    });
    // getDirSet();
    //Load TFLite Model
    loadModel().then((value) {
      print("Model Loaded");
      setState(() {
        modelLoaded = true;
        _busy = false;
      });
      pickImageFromGallery();
    });
  }

  void closeModel() async {
    await Tflite.close();
    print("Model Closed");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      appBar: AppBar(title: Text("AniMe from Photos")),
      body: Center(
        child: _imbyte != null
            ? Image.memory(_imbyte)
            : Column(
                children: [CircularProgressIndicator(), Text("Waiting...")],
              ),
      ),
    ));
  }
}
