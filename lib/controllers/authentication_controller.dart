import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../base/show_custom_message.dart';
import '../models/sign_up_model.dart';
import '../repositories/authentication_repository.dart';

class AuthenticationPageController extends GetxController implements GetxService{

  final AuthenticationRepo authRepo;

  AuthenticationPageController({
    required this.authRepo
  });

  late SignUpBody _signUpBody;
  SignUpBody get signUpBody => _signUpBody;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _uid = "";
  String get uid => _uid;

  bool _currentFBUserExists = false;
  bool get currentFBUserExists => _currentFBUserExists;


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
      update();
    }catch(e){
      showCustomSnackBar("Usuario y/o contrasena erroneos, intente nuevamente...",title: "Login usuario");
      _uid = "";
      _isLoading = false;
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

}