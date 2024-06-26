import 'package:connecthub_social/service/firebase_auth_implimentetion.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Forgot Password'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/red-black-papercut-.jpg"))),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your email ',
                    textAlign: TextAlign.center,
                  ),
                  Gap(20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                          .hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    style: const TextStyle(color: Colors.white),
                  ),
                  Gap(20),
                  ElevatedButton(
                    onPressed: () {
                      resetPassword(context);
                    },
                    child: Text('Reset Email'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> resetPassword(context) async {
    if (_formKey.currentState?.validate() ?? false) {
      FirebaseAuthService()
          .forgotPassword(context, emailController.text.trim());
    }
  }
}
