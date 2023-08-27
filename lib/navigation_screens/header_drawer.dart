import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../chat_screen_widgets/profile_provider.dart';
import '../utils/pick_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/utils.dart';

class HeaderDrawer extends StatefulWidget {
  const HeaderDrawer({Key? key}) : super(key: key);

  @override
  State<HeaderDrawer> createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  final user = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestoreReference = FirebaseFirestore.instance;//collection(collectionPath);
  late String userEmail;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    getUserEmail();
  }
  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        userEmail = user.email.toString();
        firestoreReference.collection(userEmail);
    }
  }
  Future<void> saveProfileImageUrl(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImageUrl', imageUrl);
  }
  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
    if(_image!=null) {
      Utils().toastMessage('Have Patience');
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/$userEmail/' + "profileImage");
      firebase_storage.UploadTask uploadTask = ref.putData(_image!);
      Future.value(uploadTask).then((value) async {
        var newURL = await ref.getDownloadURL();
        firestoreReference.collection(userEmail).doc("profileImage").set({
          'title': newURL.toString(),
          'id': "profileImage",
        }).then((value) {
          // Set the profile image URL in the ProfileProvider
          Provider.of<ProfileProvider>(context, listen: false)
              .setProfileImageUrl(newURL.toString());
          Utils().toastMessage('Uploaded Successfully');
          // Save the profile image URL to SharedPreferences
          saveProfileImageUrl(newURL.toString());
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageUrl =
        Provider.of<ProfileProvider>(context).profileImageUrl;
    return Container(
      color: Colors.orangeAccent,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              profileImageUrl != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(profileImageUrl),
                    )
                  : CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage(
                          'images/avatar.png'),
                    ),
              Positioned(
                child: IconButton(
                    onPressed: () => selectImage(),
                    icon: Icon(Icons.add_a_photo_outlined)),
                bottom: -10,
                left: 80,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            '$userEmail',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
