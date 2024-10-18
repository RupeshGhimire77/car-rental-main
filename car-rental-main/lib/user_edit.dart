import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({super.key});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  File file = File("");
  bool loader = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Center(
            child: SizedBox(
                height: 100,
                width: 100,
                child: file.path.isNotEmpty
                    ? CircleAvatar(backgroundImage: FileImage(file))
                    : CircleAvatar(
                        backgroundImage: AssetImage("assets/images/sedan.png"),
                      )),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: loader == true
                    ? CircularProgressIndicator()
                    : Text("Upload")),
          )
        ],
      )),
    );
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {
      loader = true;
      file;
    });
    try {
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref();
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      String? downloadUrl = await uploadReference.getDownloadURL();
      try {
        print("download url : $downloadUrl");
      } catch (e) {
        print("Could not find it");
      }

      var json = {
        "name": "romans",
        // "address": "banepa",
        "photo_url": downloadUrl,
        // "age": 12
      };
      await FirebaseFirestore.instance.collection("user").add(json);
      setState(() {
        loader = false;
      });
    } catch (e) {
      setState(() {
        loader = false;
      });
      print(e);
    }
  }
}
