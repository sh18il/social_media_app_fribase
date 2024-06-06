// ignore_for_file: library_private_types_in_public_api
import 'package:connecthub_social/view/add_page.dart';
import 'package:connecthub_social/view/all_user_page.dart';
import 'package:connecthub_social/view/auth.dart';
import 'package:connecthub_social/view/home_page.dart';
import 'package:connecthub_social/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:light_bottom_navigation_bar/light_bottom_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  var screensList = [
    HomePage(),
    // const Text('Search'),
    AddPage(),
    AllUserPage(),
    ProfilePage(),
  ];
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: LightBottomNavigationBar(
        height: 55,
        currentIndex: index,
        items: makeNavItems(),
        onSelected: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
      body: Center(child: screensList[index]),
    );
  }

  List<LightBottomNavigationBarItem> makeNavItems() {
    return [
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.home_outlined,
        selectedIcon: Icons.home_outlined,
        size: 30,
        backgroundShadowColor: Colors.red,
        borderBottomColor: Colors.red,
        borderBottomWidth: 3,
        splashColor: Colors.red,
        selectedIconColor: Colors.red,
        unSelectedIconColor: Colors.red,
      ),
      // const LightBottomNavigationBarItem(
      //   unSelectedIcon: Icons.search_outlined,
      //   selectedIcon: Icons.search_outlined,
      //   size: 30,
      //   backgroundShadowColor: Colors.blue,
      //   borderBottomColor: Colors.blue,
      //   borderBottomWidth: 3,
      //   splashColor: Colors.blue,
      //   selectedIconColor: Colors.blue,
      //   unSelectedIconColor: Colors.blue,
      // ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.post_add_sharp,
        selectedIcon: Icons.post_add_sharp,
        size: 30,
        backgroundShadowColor: Colors.yellowAccent,
        borderBottomColor: Colors.yellowAccent,
        borderBottomWidth: 3,
        splashColor: Colors.yellowAccent,
        selectedIconColor: Colors.yellowAccent,
        unSelectedIconColor: Colors.yellowAccent,
      ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.supervised_user_circle_outlined,
        selectedIcon: Icons.supervised_user_circle_outlined,
        size: 30,
        backgroundShadowColor: Colors.green,
        borderBottomColor: Colors.green,
        borderBottomWidth: 3,
        splashColor: Colors.green,
        selectedIconColor: Colors.green,
        unSelectedIconColor: Colors.green,
      ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.person_outline,
        selectedIcon: Icons.person_outline,
        size: 30,
        backgroundShadowColor: Colors.purpleAccent,
        borderBottomColor: Colors.purpleAccent,
        borderBottomWidth: 3,
        splashColor: Colors.purpleAccent,
        selectedIconColor: Colors.purpleAccent,
        unSelectedIconColor: Colors.purpleAccent,
      ),
    ];
  }
}
