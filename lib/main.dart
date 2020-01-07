import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ml_Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Ml_Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Face> _faces;

  void _getImageAndDetectFaces() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    final FirebaseVisionImage image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    final faces = await faceDetector.processImage(image);
    if (mounted) {
      setState(() {
        _faces = faces;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Detection Application'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImageAndDetectFaces,
        tooltip: 'Pick an Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImageAndFaces extends StatelessWidget {
  ImageAndFaces({this.imageFile, this.faces});
  final File imageFile;
  final List<Face> faces;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
        flex: 2,
        child: Container(
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
          ),
        ),
      ),
      Flexible(
        flex: 1,
        child: ListView(
          children: faces.map<Widget>((f) => FaceCoordinates(f)).toList(),
        ),
      ),
    ]);
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates(this.face);
  final Face face;
  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, ${pos.left}, ${pos.bottom}, ${pos.right})'),
    );
  }
}
