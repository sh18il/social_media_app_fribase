// import 'dart:io';

// import 'package:connecthub_social/controller/image_controller.dart';
// import 'package:connecthub_social/model/image_post_model.dart';
// import 'package:connecthub_social/service/image_post_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class AddPage extends StatelessWidget {
//   String? email;
//   AddPage({super.key, this.email});

//   TextEditingController descriptionCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height * 1;
//     final width = MediaQuery.of(context).size.width * 1;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 child: Consumer<ImagesProvider>(builder: (context, pro, _) {
//                   return FutureBuilder(
//                     future: Future.value(pro.pickedImage),
//                     builder: (context, snapshot) {
//                       return Container(
//                         height: height * 0.5,

//                         decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 125, 124, 122),
//                           image: snapshot.data != null
//                               ? DecorationImage(
//                                   image: FileImage(snapshot.data!),
//                                   fit: BoxFit.cover,
//                                 )
//                               : null,
//                         ),
//                       );
//                     },
//                   );
//                 }),
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     Provider.of<ImagesProvider>(context, listen: false)
//                         .pickImg();
//                   },
//                   child: Text("add pic")),
//               TextFormField(
//                 controller: descriptionCtrl,
//                 decoration: InputDecoration(border: OutlineInputBorder()),
//               ),
//               ElevatedButton(
//                   onPressed: () {
//                     add(context);
//                   },
//                   child: Text("submit")),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   add(BuildContext context) async {
//     final user = FirebaseAuth.instance.currentUser!.uid;
//     ImagePostService services = ImagePostService();
//     final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
//     await services.addImage(File(imageProvider.pickedImage!.path), context);

//     ImagePostModel imModel = ImagePostModel(
//         image: services.url, description: descriptionCtrl.text, uid: user);

//     await services.addPost(imModel);
//   }
// }
import 'dart:io';
import 'package:connecthub_social/controller/image_controller.dart';
import 'package:connecthub_social/model/image_post_model.dart';
import 'package:connecthub_social/service/image_post_service.dart';
import 'package:connecthub_social/widgets/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPage extends StatelessWidget {
  String? email;
  AddPage({super.key, this.email});

  TextEditingController descriptionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add New Post"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Consumer<ImagesProvider>(builder: (context, pro, _) {
                  return FutureBuilder<File?>(
                    future: Future.value(pro.pickedImage),
                    builder: (context, snapshot) {
                      return Container(
                        height: height * 0.4,
                        width: width,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                          image: snapshot.data != null
                              ? DecorationImage(
                                  image: FileImage(snapshot.data!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: snapshot.data == null
                            ? Center(
                                child: Text(
                                  "No image selected",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  );
                }),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<ImagesProvider>(context, listen: false)
                        .pickImg();
                  },
                  icon: Icon(Icons.add_a_photo),
                  label: Text("Add Picture"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: descriptionCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    add(context);
                  },
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  add(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    ImagePostService services = ImagePostService();
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    if (imageProvider.pickedImage != null) {
      await services.addImage(File(imageProvider.pickedImage!.path), context);

      ImagePostModel imModel = ImagePostModel(
          image: services.url, description: descriptionCtrl.text, uid: user);

      await services.addPost(imModel);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(),
        ),
        (route) => false,
      ); // Navigate back after submitting
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an image.")),
      );
    }
  }
}
