import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:kamal_limited/Screens/MainScreens/Home.dart';
import 'package:kamal_limited/Screens/Starting/Login.dart';
import 'package:kamal_limited/authenticatons/exceptions/SignInWithEmailAndPassFail.dart';

class AuthenticationRepo extends GetxController {
  static AuthenticationRepo get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;


  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    user == null ? Get.offAll(() => const Login()) : Get.offAll(() => const Home());
  }

  Future<void> createUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null? Get.offAll(()=> const Home()) : Get.to(() => const Login());
    }
    on FirebaseAuthException catch (e) {
      final  ex = SignInWithEmailAndPass.code(e.code);
      print('FIREBASE AUTH EXCEPTION - ${ex.message}');
      throw ex;
    }
    catch (_) {
      const ex = SignInWithEmailAndPass();
      print('EXCEPTION - ${ex.message}');
      throw ex;

    }
  }

  Future<void> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    }
    on FirebaseAuthException catch (e) {}
    catch (_) {}
  }


  Future<void> logout() async => await _auth.signOut();

}