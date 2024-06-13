// ignore_for_file: library_private_types_in_public_api
import 'package:connecthub_social/view/add_page.dart';
import 'package:connecthub_social/view/all_user_page.dart';
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
    const HomePage(),
    // const Text('Search'),
    AddPage(),
    const AllUserPage(),
    const ProfilePage(),
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
        backgroundShadowColor: Color.fromARGB(255, 219, 212, 212),
        borderBottomColor: Color.fromARGB(255, 246, 246, 246),
        borderBottomWidth: 3,
        splashColor: Color.fromARGB(255, 255, 255, 255),
        selectedIconColor: Color.fromARGB(255, 255, 255, 255),
        unSelectedIconColor: Colors.white,
      ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.post_add_sharp,
        selectedIcon: Icons.post_add_sharp,
        size: 30,
        backgroundShadowColor: Color.fromARGB(255, 219, 212, 212),
        borderBottomColor: Color.fromARGB(255, 246, 246, 246),
        borderBottomWidth: 3,
        splashColor: Color.fromARGB(255, 255, 255, 255),
        selectedIconColor: Color.fromARGB(255, 255, 255, 255),
        unSelectedIconColor: Colors.white,
      ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.supervised_user_circle_outlined,
        selectedIcon: Icons.supervised_user_circle_outlined,
        size: 30,
        backgroundShadowColor: Color.fromARGB(255, 219, 212, 212),
        borderBottomColor: Color.fromARGB(255, 246, 246, 246),
        borderBottomWidth: 3,
        splashColor: Color.fromARGB(255, 255, 255, 255),
        selectedIconColor: Color.fromARGB(255, 255, 255, 255),
        unSelectedIconColor: Colors.white,
      ),
      const LightBottomNavigationBarItem(
        unSelectedIcon: Icons.person_outline,
        selectedIcon: Icons.person_outline,
        size: 30,
        backgroundShadowColor: Color.fromARGB(255, 219, 212, 212),
        borderBottomColor: Color.fromARGB(255, 246, 246, 246),
        borderBottomWidth: 3,
        splashColor: Color.fromARGB(255, 255, 255, 255),
        selectedIconColor: Color.fromARGB(255, 255, 255, 255),
        unSelectedIconColor: Colors.white,
      ),
    ];
  }
}
