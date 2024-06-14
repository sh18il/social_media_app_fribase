import 'package:connecthub_social/view/add_page.dart';
import 'package:connecthub_social/view/all_user_page.dart';
import 'package:connecthub_social/view/home_page.dart';
import 'package:connecthub_social/view/profile.dart';
import 'package:flutter/material.dart';

class BottomController extends ChangeNotifier {
  var index = 0;

  var screensList = [
    const HomePage(),
    // const Text('Search'),
    AddPage(),
    const AllUserPage(),
    const ProfilePage(),
  
  ];

  value(index) {
    this.index = index;
    notifyListeners();
  }
}
