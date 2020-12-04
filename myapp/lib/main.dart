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
  List<dynamic> dataImg = [
    'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Flag_of_None_%28square%29.svg/768px-Flag_of_None_%28square%29.svg.png'
  ];
  int index = 0;

  void _uploadImage() async {
    // var now = new DateTime.now();
    ImagePicker picker = ImagePicker();
    PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);

    File originalImage = File(pickedImage.path);

    setState(() {
      image = originalImage;
      dataImg = [
        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Flag_of_None_%28square%29.svg/768px-Flag_of_None_%28square%29.svg.png'
      ];
    });
    // var end = new DateTime.now();
    // var re = end.difference(now);
    // print(re);
  }

  // Future imageSend() async {
  //   var response = await http.get('https://10.0.105.202:8000/send');
  //   print(response.body);
  // }

  Future uploadToServer() async {
    if (image == null) return;
    img.Image imageTemp = img.decodeImage(image.readAsBytesSync());
    img.Image resizeImg = img.copyResize(imageTemp, width: 800, height: 500);
    var thumb = img.encodeJpg(resizeImg);
    String base64Image = base64.encode(thumb);
    String fileName = image.path.split("/").last;

    // var now = new DateTime.now();

    Response response = await Dio()
        .post('http://service.mmlab.uit.edu.vn/receipt/task3/send', data: {
      "image-name": fileName,
      "base64": base64Image,
    });
    print(fileName);
    // var end = new DateTime.now();
    // var re = end.difference(now);
    // print(re);

    // print(response.statusCode);
    // print(response.data['image-name']);
    // print(response_1.data);
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
  Future getResult() async {
    String fileName = image.path.split("/").last;
    print(fileName);
    var now = new DateTime.now();

    Response response_1 = await Dio()
        .post('http://service.mmlab.uit.edu.vn/receipt/task3/result', data: {
      "image-name": fileName,
      "filter-id": [0, 1, 2],
    });
    var jsonData_1 = response_1.data;
    var jsonFix_1 = jsonData_1.replaceAll("'", '"');
    var myData_1 = json.decode(jsonFix_1);
    print(myData_1);
    dataImg.addAll(myData_1);

    Response response_2 = await Dio()
        .post('http://service.mmlab.uit.edu.vn/receipt/task3/result', data: {
      "image-name": fileName,
      "filter-id": [3, 4, 5],
    });

    var jsonData_2 = response_2.data;
    var jsonFix_2 = jsonData_2.replaceAll("'", '"');
    var myData_2 = json.decode(jsonFix_2);
    print(myData_2);
    dataImg.addAll(myData_2);

    Response response_3 = await Dio()
        .post('http://service.mmlab.uit.edu.vn/receipt/task3/result', data: {
      "image-name": fileName,
      "filter-id": [6, 7, 8],
    });

    var jsonData_3 = response_3.data;
    var jsonFix_3 = jsonData_3.replaceAll("'", '"');
    var myData_3 = json.decode(jsonFix_3);
    print(myData_3);
    dataImg.addAll(myData_3);

    var end = new DateTime.now();
    var re = end.difference(now);
    print(re);
  }

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
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Center(
                    child: dataImg.length == 1
                        ? (image != null
                            ? Image.file(
                                image,
                                // fit: BoxFit.fitWidth,
                                width: 410,
                                height: 500,
                              )
                            : null)
                        : Image.network(dataImg[index], width: 410, height: 500,)),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 1;
                      });
                    },
                    child: Text(
                      'gray',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 2;
                      });
                    },
                    child: Text(
                      'sketch',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 3;
                      });
                    },
                    child: Text(
                      'buw_pencil',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 4;
                      });
                    },
                    child: Text(
                      'water_color',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 5;
                      });
                    },
                    child: Text(
                      'oil_painting',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 6;
                      });
                    },
                    child: Text(
                      'cold',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 7;
                      });
                    },
                    child: Text(
                      'warm',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 8;
                      });
                    },
                    child: Text(
                      'cartoonizer',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        index = 9;
                      });
                    },
                    child: Text(
                      'colorization',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: uploadToServer,
                    child: Text(
                      'Upload',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    onPressed: getResult,
                    child: Text(
                      'Get result',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              )
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
