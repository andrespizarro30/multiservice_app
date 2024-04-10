
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiservice_app/utils/app_constants.dart';

import '../models/sign_up_model.dart';

class AuthenticationRepo{

  FirebaseAuth firebaseAuth;
  FirebaseFirestore firebaseFirestore;

  AuthenticationRepo({
    required this.firebaseAuth,
    required this.firebaseFirestore
  });

  Future<UserCredential> signUpWithEmailAndPassword(SignUpBody signUpBody)async{

    try{
      UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: signUpBody.email!, password: signUpBody.password!);
      userCredential.user!.updateDisplayName(signUpBody.name);
      userCredential.user!.updatePhotoURL(signUpBody.phone);
      return userCredential;
    }on FirebaseException catch(e){
      throw Exception(e.code);
    }

  }

  Future<UserCredential> signInWithEmailAndPassword(SignUpBody signUpBody)async{

    try{
      UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: signUpBody.email!, password: signUpBody.password!);

      firebaseFirestore.collection(AppConstants.FIRESTORE_USERS_COLLECTION).doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid!,
          'email': userCredential.user!.email!
        },
        SetOptions(merge: true)
      );

      return userCredential;
    }on FirebaseException catch(e){
      throw Exception(e.code);
    }

  }

  Future<bool> verifyCurrentUser() async{
    if(firebaseAuth.currentUser != null){
      return true;
    }else{
      return false;
    }
  }

  Future<void> signOut() async{
    return await firebaseAuth.signOut();
  }

}