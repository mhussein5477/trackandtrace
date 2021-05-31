import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:geolocator/geolocator.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Stream<String> get onAuthStateChanged => _firebaseAuth.onAuthStateChanged.map(
        (FirebaseUser user) => user?.uid,
      );

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(
      String email, String password, String name) async {
    final currentUser = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    // add into users
    Firestore.instance.collection('users').add({
      "name" :  name.toLowerCase(),
      "type" :  "" ,
      "uid" : currentUser.uid,
      "lat" : [],
      "long" : [],
    });

    // location of the user
    var position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
    var lastposition = await Geolocator.getLastKnownPosition();
    print(lastposition);
    var lat = position.latitude;
    var long = position.longitude;
    print("$lat , $long");
    var list = [lat];
    var list1 = [long];

    Firestore.instance.collection('users').where("uid", isEqualTo: currentUser.uid).getDocuments().then(
          (QuerySnapshot snapshot) => {
        snapshot.documents.forEach((f) {
          //storing the location
          Firestore.instance.collection('users').document(f.reference.documentID).updateData({
            "lat": FieldValue.arrayUnion(list),
            "long": FieldValue.arrayUnion(list1)
          });
          print("documentID---- " + f.reference.documentID);
        }),
      },
    );
    // Update the username
    await updateUserName(name, currentUser);
    return currentUser.uid;
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }


  // Email & Password Sign In
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;

    // location of the user
    var position = await Geolocator.getCurrentPosition( desiredAccuracy: LocationAccuracy.high);
    var lastposition = await Geolocator.getLastKnownPosition();
    print(lastposition);
    var lat = position.latitude;
    var long = position.longitude;
    print("$lat , $long");
    var list = [lat];
    var list1 = [long];
    var  uid =  (await FirebaseAuth.instance.currentUser()).uid;

    Firestore.instance.collection('users').where("uid", isEqualTo: uid).getDocuments().then(
          (QuerySnapshot snapshot) => {
        snapshot.documents.forEach((f) {
          //storing the location
          Firestore.instance.collection('users').document(f.reference.documentID).updateData({
            "lat": FieldValue.arrayUnion(list),
            "long": FieldValue.arrayUnion(list1)
          });
          print("documentID---- " + f.reference.documentID);

        }),
      },
    );





    return user.uid;
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  //convert the anonymous user to a real user by updating the email of the anonymous user in firebase
  Future convertUserWithEmail(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();

    final credential = EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  Future converWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    FirebaseUser user = (await _firebaseAuth.signInWithCredential(credential)).user;
    return user.uid;
  }

}


class NameValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Name can't be empty";
    }
    if(value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if(value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if(value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }
}