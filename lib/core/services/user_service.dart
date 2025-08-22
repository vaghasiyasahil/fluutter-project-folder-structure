import 'dart:convert';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../export.dart';

class UserService {
  static final auth = FirebaseAuth.instance;
  static final cloudFireStore = FirebaseFirestore.instance;
  static final userCollection = "Users";
  static final googleSignIn = GoogleSignIn();
  static UserModel? user;

  static final userRef = cloudFireStore.collection(userCollection).withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  static Future<UserCredential> loginWithEmail({required String email, required String password}) async {
    try {
      final user = await auth.signInWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      Loader.closeLoader();
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      } else if (e.code == 'invalid-credential') {
        showToast('Your email or password is wrong.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signupWithEmail({required String email, required String password}) async {
    try {
      final user = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      Loader.closeLoader();
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      Loader.closeLoader();
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithApple() async {
    try {
      await auth.signOut();
      final rawNonce = generateNonce();
      final bytes = utf8.encode(rawNonce);
      final digest = sha256.convert(bytes);
      final nonce = digest.toString();
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
      final oauthCredential =
          OAuthProvider("apple.com").credential(idToken: appleCredential.identityToken, rawNonce: rawNonce, accessToken: appleCredential.authorizationCode);
      return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    } on FirebaseAuthException catch (e) {
      Loader.closeLoader();
      if (e.code == 'weak-password') {
        showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showToast('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> createUser({
    String? firstName,
    String? lastName,
    required String loginType,
    required UserCredential userCredential,
  }) async {
    try {
      final userData = await userRef.doc(userCredential.user?.uid).get();
      final deviceId = await GlobalConfig.getDeviceId();
      final fcmToken = await NotificationService.instance.getDeviceToken();
      if (userData.exists) {
        if (userData.data()?.isBlocked == true) {
          auth.signOut();
          googleSignIn.signOut();
          throw "This account has been deleted.";
        } else {
          await userRef.doc(userCredential.user?.uid).update({
            'last_login': Timestamp.now(),
            'device_id': deviceId,
            'fcm_token': fcmToken,
          });
          user = userData.data();
          return userData.data();
        }
      } else {
        await userRef.doc(userCredential.user?.uid).set(UserModel(
              firstName: userCredential.user?.displayName ?? firstName,
              email: userCredential.user?.email,
              lastName: lastName,
              uid: userCredential.user?.uid,
              profileUrl: userCredential.user?.photoURL,
              purchasedEssays: [],
              loginType: loginType,
              isBlocked: false,
              deviceId: deviceId,
              fcmToken: fcmToken,
            ));
        final data = await userRef.doc(userCredential.user?.uid).get();
        user = data.data();
        return data.data();
      }
    } on FirebaseException catch (e) {
      Loader.closeLoader();
      showToast(e.message ?? 'Something went wrong!');
    } catch (e) {
      Loader.closeLoader();
      if (e is String) {
        showToast(e);
      } else {
        showToast('Something went wrong!');
      }
      rethrow;
    }
    return null;
  }

  static Future<void> blockUser() async {
    try {
      await userRef.doc(auth.currentUser?.uid).update({'is_blocked': true});
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> getUser() async {
    try {
      final data = await userRef.doc(auth.currentUser?.uid).get();
      final deviceId = await GlobalConfig.getDeviceId();
      if (data.exists && deviceId == data.data()?.deviceId) {
        user = data.data();
        return data.data();
      }else{
        await logOut();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  static Future<void> updatePurchasedList(List<int> newEssay) async {
    try {
      await userRef.doc(auth.currentUser?.uid).update({'purchased_essays': FieldValue.arrayUnion(newEssay)});
      await getUser();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> updateUser({
    String? firstName,
    String? lastName,
    String? profileUrl,
  }) async {
    try {
      await userRef.doc(auth.currentUser?.uid).update({'first_name': firstName, 'last_name': lastName, 'profile_url': profileUrl});
      await getUser();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logOut() async {
   await UserService.auth.signOut();
   await UserService.googleSignIn.signOut();
   await HiveHelper.clearHive();
    // Get.offAllNamed(Routes.homeScreen);
  }
}
