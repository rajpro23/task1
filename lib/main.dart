import 'dart:io';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'Utility.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaveImageDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class SaveImageDemo extends StatefulWidget {
  SaveImageDemo() : super();

  final String title = "Flutter Save Image in Preferences";

  @override
  _SaveImageDemoState createState() => _SaveImageDemoState();
}

class _SaveImageDemoState extends State<SaveImageDemo> {

  Future<File> imageFile, imageFile2;
  Image imageFromPreferences;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile2 = ImagePicker.pickImage(source: source);

    });
  }
  pickImageFromCamera(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(img);
      });
    });
  }
  Widget imageFromCamera() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          Utility.saveImageToPreferences(Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(snapshot.data,);
        } else if (null != snapshot.error) {
          return 'Error Picking Image'.text.makeCentered();
        } else {
          return const Text('No Image Selected', textAlign: TextAlign.center,);
        }
      },
    );
  }
  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile2,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot1) {
        if (snapshot1.connectionState == ConnectionState.done &&
            null != snapshot1.data) {
          Utility.saveImageToPreferences(Utility.base64String(snapshot1.data.readAsBytesSync()));
          return Image.file(snapshot1.data,);
        } else if (null != snapshot1.error) {
          return 'Error Picking Image'.text.makeCentered();
        } else {
          return 'No Image Selected'.text.makeCentered();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadImageFromPreferences();
            },
          ),
        ],
      ),
      body: VStack([
        new Container(
          padding: const EdgeInsets.all(10.0),
          child: VStack([
            imageFile == null
                ?  Container(
              height: 250.0,
              width: 400.0,
              child: new Icon(
                Icons.image,
                size: 250.0,
                color: Theme.of(context).primaryColor,
              ),
            )
                :  SizedBox(
              height: 200.0,
              width: 500,
              child: imageFromCamera(),
            ),
            RaisedButton.icon(
                onPressed: () {
                  pickImageFromCamera(ImageSource.camera);
                  setState(() {
                    imageFromPreferences = null;
                  });
                },
                icon: new Icon(Icons.image),
                label:  'Pick-Up Images'.text.make())
          ],alignment: MainAxisAlignment.center,crossAlignment: CrossAxisAlignment.center,),
        ),
        new Container(
          padding: const EdgeInsets.all(2.0),
          child: VStack([
            imageFile2 == null
                ?  Container(
              height: 250.0,
              width: 400.0,
              child: new Icon(
                Icons.image,
                size: 250.0,
                color: Theme.of(context).primaryColor,
              ),
            )
                :  SizedBox(
              height: 200.0,
              width: 500,
              child: imageFromGallery(),
            ),
            RaisedButton.icon(
                onPressed: () {
                  pickImageFromGallery(ImageSource.gallery);
                  setState(() {
                    imageFromPreferences = null;
                  });
                },
                icon: new Icon(Icons.image),
                label:  'Pick-Up Images'.text.make())
          ],alignment: MainAxisAlignment.center,crossAlignment: CrossAxisAlignment.center,),
        ),
      ]),
    );
  }
}


