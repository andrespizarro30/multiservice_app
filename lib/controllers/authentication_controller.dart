import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../models/sign_up_model.dart';
import '../repositories/authentication_repository.dart';

class AuthenticationPageController extends GetxController implements GetxService{

  final AuthenticationRepo authRepo;
  FirebaseAuth firebaseAuth;
  FirebaseStorage firebaseStorage;

  AuthenticationPageController({
    required this.authRepo,
    required this.firebaseAuth,
    required this.firebaseStorage
  });

  late SignUpBody _signUpBody = SignUpBody();
  SignUpBody get signUpBody => _signUpBody;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _uid = "";
  String get uid => _uid;

  bool _currentFBUserExists = false;
  bool get currentFBUserExists => _currentFBUserExists;

  String _profileImageURL = "";
  String get profileImageURL => _profileImageURL;

  int _tapsCount = 0;
  int get tapsCount => _tapsCount;

  bool _isTechnician = false;
  bool get isTechnician => _isTechnician;

  Future<void> registration(SignUpBody signUpBody) async{
    _isLoading = true;
    update();
    try{
      UserCredential userCredential = await authRepo.signUpWithEmailAndPassword(signUpBody);
      if(userCredential != null){
        showCustomSnackBar("Usuario creado exitosamente!!!",title: "Creación Usuario", backgroundColor: Colors.lightGreenAccent);
      }
      _isLoading = false;
      update();
    }catch(e){
      showCustomSnackBar("Error al intentar crear usuario, intente nuevamente...",title: "Creación Usuario");
      _isLoading = false;
      update();
    }

  }

  Future<void> login(SignUpBody signUpBody) async{
    _isLoading = true;
    update();
    try{
      UserCredential userCredential = await authRepo.signInWithEmailAndPassword(signUpBody);
      if(userCredential != null){
        _uid = userCredential.user!.uid!;
      }
      _isLoading = false;
      getProfileData();
    }catch(e){
      showCustomSnackBar("Usuario y/o contrasena erroneos, intente nuevamente...",title: "Login usuario");
      _uid = "";
      _isLoading = false;
      update();
    }

  }

  Future<void> getProfileData() async{

    var firebaseAuth = await authRepo.getProfileData();

    var dataList = firebaseAuth.currentUser!.displayName!.split(";");

    _signUpBody.name = dataList[0];
    _signUpBody.phone = dataList[1];
    _signUpBody.userType = dataList[2];
    _signUpBody.email = firebaseAuth.currentUser!.email;

    _profileImageURL = firebaseAuth.currentUser!.photoURL != null ? firebaseAuth.currentUser!.photoURL! : "";

    update();

  }

  Future<void> updatePhotoProfile(String appCurrentDirectory, File imageFile) async{

    List<String> pathParts = imageFile.path.split("/");

    String fileName = pathParts[pathParts.length-1];

    final Reference refStorage = firebaseStorage.ref().child("MyPhotoProfile")
        .child(firebaseAuth.currentUser!.uid!)    
        .child(fileName);


    final UploadTask uploadTask = refStorage.putFile(imageFile);

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);

    if(taskSnapshot.state == TaskState.success){
      final String photoURL = await taskSnapshot.ref.getDownloadURL();
      firebaseAuth.currentUser!.updatePhotoURL(photoURL);
      _profileImageURL = photoURL;
      update();
    }

  }

  Future<void> verifyCurrentUser() async{
    _currentFBUserExists = await authRepo.verifyCurrentUser();
    update();
  }

  void signOut() async{
    await authRepo.signOut();
  }

  void addTapCount(){
    _tapsCount = _tapsCount + 1;
    update();
  }

  void setIfTechnician(){
    _isTechnician = !_isTechnician;
    update();
  }

}