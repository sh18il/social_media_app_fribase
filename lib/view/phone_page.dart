import 'package:connecthub_social/service/firebase_phone_auth.dart';
import 'package:connecthub_social/view/auth.dart';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PhoneOtpPage extends StatelessWidget {
  PhoneOtpPage({super.key});
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneCtrl = TextEditingController();
    TextEditingController otpCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
                "assets/images/a-sleek-and-modern-3d-render-of-the-connect-hub-lo-aDv3q1bOTGO9qCZ23zbUWg-EVwOSYhYQiOQxM4Ubzil_A-removebg-preview.png"),
          )),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phoneCtrl,
                    decoration: const InputDecoration(
                      prefix: Text("+91"),
                      prefixIcon: Icon(Icons.phone),
                      labelText: "Enter Phone Number",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.length != 10) return "invalid phone number";
                      return null;
                    },
                  ),
                ),
                const Gap(20),
                ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        PhoneOtpAuth.sentOtp(
                            phone: phoneCtrl.text,
                            errorStep: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                        content: Text(
                                  "Error in sending otp ",
                                ))),
                            nextStep: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("otp verification"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text("Enter 6 digit Otp"),
                                      const Gap(15),
                                      Form(
                                        key: formKey1,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: otpCtrl,
                                          decoration: const InputDecoration(
                                            labelText: "Enter Phone Number",
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value!.length != 6) {
                                              return "invalid otp number";
                                           
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          if (formKey1.currentState!
                                              .validate()) {
                                            PhoneOtpAuth.loginWithOtp(
                                                    otp: otpCtrl.text)
                                                .then((value) {
                                              if (value == "Success") {
                                                Navigator.pop(context);
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AuthPage(),
                                                ));
                                              }
                                            });
                                          }
                                        },
                                        child: const Text("Submit"))
                                  ],
                                ),
                              );
                            });
                      }
                    },
                    style: const ButtonStyle(
                        elevation: WidgetStatePropertyAll(25),
                        backgroundColor: WidgetStatePropertyAll(Colors.amber)),
                    child: const Text("Send Otp"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
