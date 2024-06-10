import 'package:firebase_auth/firebase_auth.dart';

class PhoneOtpAuth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static String verifyId = "";
  // sent otp user
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await auth
          .verifyPhoneNumber(
        timeout: Duration(seconds: 30),
        phoneNumber: "+91$phone",
        verificationCompleted: (phoneAuthCredential) async {
          return;
        },
        verificationFailed: (error) {
          return;
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          return;
        },
      )
          .onError(
        (error, stackTrace) {
          errorStep();
        },
      );
    } catch (e) {}
  }

//veryfy otp and login
  static Future loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await auth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Enter in otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Future<void> verifyPhoneNumber(String phoneNumber) async {
  //   await _auth.verifyPhoneNumber(
  //     phoneNumber: phoneNumber,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       // Auto-retrieve verification code
  //       await _auth.signInWithCredential(credential);
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       // Verification failed
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       // Save the verification ID for future use
  //       String smsCode = 'xxxxxx'; // Code input by the user
  //       PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //         verificationId: verificationId,
  //         smsCode: smsCode,
  //       );
  //       // Sign the user in with the credential
  //       await _auth.signInWithCredential(credential);
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //     timeout: Duration(seconds: 60),
  //   );
  // }
}
