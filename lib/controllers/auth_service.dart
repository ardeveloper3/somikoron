import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  //create a new account
  static Future<String> createAccountWithEmail(
      String name,String password
      )async{
    try{
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: "$name@gmail.com", password: password);
      return "Account Created";
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }catch(e){
      return e.toString();
    }
  }

  //login Methode
  static Future<String> loginWithEmail(
      String name,String password
      )async{
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: "$name@gmail.com", password: password);
      return "Login Successful";
    }on FirebaseAuthException catch(e){
      return e.message.toString();
    }catch(e){
      return e.toString();
    }
  }

  //logout the user
  static Future logout()async{
    await FirebaseAuth.instance.signOut();
  }

  //check weather the user is sign in or not

static  Future<bool> isLoggedIn() async{
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
}

}