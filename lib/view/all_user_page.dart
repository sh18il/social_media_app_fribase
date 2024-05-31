import 'package:connecthub_social/model/auth_model.dart';
import 'package:connecthub_social/service/user_service.dart';
import 'package:flutter/material.dart';

class AllUserPage extends StatelessWidget {
  const AllUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: UserService().getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("error code"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    hoverColor: const Color.fromARGB(255, 158, 157, 153),
                    tileColor: Colors.blueAccent,
                    leading: CircleAvatar(),
                    trailing:
                        ElevatedButton(onPressed: () {}, child: Text('Follow')),
                    title: Text(data.username.toString()),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
