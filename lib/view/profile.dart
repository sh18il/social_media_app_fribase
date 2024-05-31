import 'package:connecthub_social/service/profile_service.dart';
import 'package:connecthub_social/view/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        leading: Text(user!.displayName.toString()),
        title: Text(user!.email.toString()),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ));
              },
              icon: Icon(Icons.logout_sharp)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(),
                        Column(
                          children: [Text("FOLLOWERS"), Text("0")],
                        ),
                        Column(
                          children: [Text("FOLLOWING"), Text("0")],
                        )
                      ],
                    ),
                    Gap(25),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        width: width * 0.5,
                        height: height * 0.04,
                        child: Center(
                            child: Text(
                          "Edit Profile",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    )
                  ],
                ),
              ),
           Expanded(child:    StreamBuilder(stream: ,
              
               builder: (context, snapshot) {
                if (snapshot.connectionState==ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(),);
                }

              },))
            ],
          ),
        ),
      ),
    );
  }
}
