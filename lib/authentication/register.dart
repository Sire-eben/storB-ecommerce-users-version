import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fstorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../Global/global.dart';
import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String userImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(message: "Select an image");
          });
    } else {
      if (passwordController.text == confirmController.text) {
        //start app

        if (confirmController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return const LoadingDialog(message: "Setting up your account");
              });
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fstorage.Reference reference = fstorage.FirebaseStorage.instance
              .ref()
              .child("users")
              .child(fileName);
          fstorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fstorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            userImageUrl = url;

            //save info to firebase
            authenticateMerchantAndSignup();
          });
        } else {
          return showDialog(
              context: context,
              builder: (c) {
                return const ErrorDialog(message: 'Fields cannot be empty');
              });
        }
      } else {
        return showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(message: 'Passwords do not match!');
            });
      }
    }
  }

  void authenticateMerchantAndSignup() async {
    User? currentUser;

    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()).then((auth) {
          currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString());
          });
    });

    if(currentUser != null){
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        //send to home screen
        Route newRoute = MaterialPageRoute(builder: (c)=> const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser.uid)
        .set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameController.text.trim(),
      "photoUrl": userImageUrl,
      "status":"Approved",
      "userCart": ['garbageValue'],
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("photoUrl", userImageUrl);
    await sharedPreferences!.setStringList("userCart", ['garbageValue']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: "Name",
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObscure: true,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: confirmController,
                  hintText: "Confirm Password",
                  isObscure: true,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(32))),
            height: 60,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () {
                  formValidation();
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }
}
