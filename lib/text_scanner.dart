import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'detail_screen.dart';
import 'image_selector.dart';

class TextScanner extends StatefulWidget {
  TextScanner({Key? key}) : super(key: key);

  @override
  State<TextScanner> createState() => _TextScannerState();
}

class _TextScannerState extends State<TextScanner> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              _showPicker(context);
            },
            child: const Text('Pick image'),
          ),
        ),
      ),
    );
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text('Library',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor)),
                    onTap: () async {
                      File? selectedImage = await ImageSelector()
                          .getSelectedImage(ImageSource.gallery);
                      print('imagepath is=== ${selectedImage!.path}');
                      final Directory dir = await getApplicationDocumentsDirectory();
                      String dirPath = dir.path;
                      DateTime dateTime = DateTime.now();
                      String strDate = dateTime.toString();
                      final String filePath = '$dirPath/$strDate.jpg';
                      if(imageFile != null) {
                        imageFile = null;
                      }
                      imageFile = await selectedImage.copy(filePath);
                      setState(() {
                      });
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                imagePath: imageFile!.path,
                              )));
                    }),
                ListTile(
                  leading: Icon(
                    Icons.photo_camera,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text('Camera',
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).primaryColor)),
                  onTap: () async {
                    File? selectedImage = await ImageSelector()
                        .getSelectedImage(ImageSource.camera);
                    print('imagepath is=== ${selectedImage!.path}');
                    final Directory dir = await getApplicationDocumentsDirectory();
                    String dirPath = dir.path;
                    final String filePath = '$dirPath/image.jpg';
                    if(imageFile != null) {
                      imageFile = null;
                    }
                    imageFile = await selectedImage.copy(filePath);
                    setState(() {
                    });
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              imagePath: imageFile!.path,
                            )));
                  },
                ),
              ],
            ),
          );
        });
  }
}
