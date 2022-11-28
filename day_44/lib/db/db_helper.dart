import 'package:day_44/pages/sing_up.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbHelper {
  SingUp(email, password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? autCredential = _userCredential.user;
      if (autCredential!.uid.isNotEmpty) {
        return "value";
      } else {
        return "no value";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {}
  }

  singIn(email, password) async {
    try {
      UserCredential _userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User? autCredential = _userCredential.user;
      if (autCredential!.uid.isNotEmpty) {
        return "value";
      } else {
        return "no value";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } catch (e) {}
  }
}
