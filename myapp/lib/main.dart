import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load image from Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Load image from Gallery'),
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
  File image;
  Image image2;

  void _uploadImage() async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);

    File originalImage = File(pickedImage.path);

    setState(() => image = originalImage);
  }

  // Future imageSend() async {
  //   var response = await http.get('https://10.0.105.202:8000/send');
  //   print(response.body);
  // }

  Future uploadToServer() async {
    if (image == null) return;
    img.Image image_temp = img.decodeImage(image.readAsBytesSync());
    img.Image resize_img = img.copyResize(image_temp, width: 700, height: 500);
    var thumb = img.encodeJpg(resize_img);
    String base64Image = base64.encode(thumb);
    String fileName = image.path.split("/").last;

    Response response_1 = await Dio()
        .post('http://service.mmlab.uit.edu.vn/receipt/task3/send', data: {
      "image-name": 'test_fluter.jpg',
      "base64": base64Image,
    });
    // Response response = await Dio()
    //     .post('http://service.mmlab.uit.edu.vn/receipt/task3/result', data: {
    //   "image-name": 'test_fluter.jpg',
    //   "filter-id": 1,
    // });
    // print(response.statusCode);
    // print(response.data['image-name']);
    print(response_1.data);
    // print(response.data['base64']);
    // print(response.headers);
    // print(response.request);
    // String uri = response.data['base64'];
    // Uint8List _bytes = base64.decode(uri);
    // // Save to gallery
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // String fullPath = '$dir/abc.jpg';
    // File file = File(fullPath);
    // await file.writeAsBytes(_bytes);
    // print(file.path);

    // final result = await ImageGallerySaver.saveImage(_bytes);
    // print(result);

    // return file.path;
    // // Display image
    // image2 = Image.memory(_bytes);
  }

  // // Save image to gallery
  // void requestPersmission() async {
  //   await PermissionHandler().requestPermissions([PermissionGroup.storage]);
  // }

  // @override
  // void initState() {
  //   requestPersmission();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: image != null
                        ? Image.file(
                            image,
                            width: 411,
                            height: 500,
                          )
                        : null),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'On Click',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'On Click 2',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {},
                    child: Text(
                      'On Click 3',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  RaisedButton(
                    onPressed: uploadToServer,
                    child: Text(
                      'Upload',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadImage,
        tooltip: 'Increment',
        child: Icon(Icons.image),
      ),
    );
  }
}
