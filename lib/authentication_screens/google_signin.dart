import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthSignIn {
  Future<UserCredential> authenticateWithGoogle() async{
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication auth = await user!.authentication;
    final credentials = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credentials);
  }
}