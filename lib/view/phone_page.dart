import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PhoneOtpPage extends StatelessWidget {
  const PhoneOtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
                "assets/images/a-sleek-and-modern-3d-render-of-the-connect-hub-lo-aDv3q1bOTGO9qCZ23zbUWg-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png"),
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: phoneCtrl,
                  decoration: InputDecoration(
                    prefix: Text("+91"),
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Enter Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                Gap(20),
                ElevatedButton(
                    onPressed: () {},
                    child: Text("Send Otp"),
                    style: ButtonStyle(
                        elevation: WidgetStatePropertyAll(25),
                        backgroundColor: WidgetStatePropertyAll(Colors.amber)))
              ],
            ),
          ),
        ),
      ),
    );
  }
  sendCode()async{
try {
  TextEditingController phoneAuthCtrl =TextEditingController();
      await FirebaseAuth.instance.verifyPhoneNumber(
        //  phoneAuthCtrl :"+91"+phoneAuthCtrl.text,
        verificationCompleted: verificationCompleted, verificationFailed: verificationFailed, codeSent: codeSent, codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)

} catch (e) {
  print(e); 
}
  }
}
