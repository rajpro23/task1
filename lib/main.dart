import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'DbHelpers.dart';
import 'Utility.dart';
import 'dart:async';
import 'modelclass.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SaveImageDemoSQLite(),
      debugShowCheckedModeBanner: false,
    );
  }
}


class SaveImageDemoSQLite extends StatefulWidget {
  //
  SaveImageDemoSQLite() : super();

  final String title = "Flutter Save Image Machine Testing";

  @override
  _SaveImageDemoSQLiteState createState() => _SaveImageDemoSQLiteState();
}

class _SaveImageDemoSQLiteState extends State<SaveImageDemoSQLite> {
  DBHelper dbHelper;
  List<Photo> images;


  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper();
    refreshImagesGallery();
  }

  refreshImagesGallery() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        images.clear();
        images.addAll(imgs);
      });
    });

  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imgFile) {
      String imgString = Utility.base64String(imgFile.readAsBytesSync());
      Photo photo = Photo(0, imgString);
      dbHelper.save(photo);
      refreshImagesGallery();
    });
  }
  /*listviewCamera() {
    return Container(
      height: 280,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              childAspectRatio: 1.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: imagec.map((photoc) {
                return Utility.imageFromBase64String(photoc.photo_namec);
              }).toList(),
            ).expand(),
            10.heightBox,
            RaisedButton.icon(
                onPressed: pickImageFromCamera,
                icon: new Icon(Icons.camera),
                label: new Text("Pick-Up Camera Images")),
          ],
        ),
      ),
    );
  }*/

  listviewGallery() {
    return Container(
      height: 300,
      child: Padding(
        padding: EdgeInsets.all(7.0),
        child: Column(
          children: [
            GridView.count(
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1,
              childAspectRatio: 1.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: images.map((photo) {
                return Utility.imageFromBase64String(photo.photo_name);
              }).toList(),
            ).expand(),
            10.heightBox,
            RaisedButton.icon(
                onPressed: pickImageFromGallery,
                icon: new Icon(Icons.image),
                label: new Text("Pick-Up Images")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            /*Flexible(
              child: listviewCamera(),
            ),*/
            Flexible(
              child: listviewGallery(),
            )
          ],
        ),
      ),
    );
  }
}
