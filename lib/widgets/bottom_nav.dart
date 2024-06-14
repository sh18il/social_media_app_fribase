// ignore_for_file: library_private_types_in_public_api
import 'package:connecthub_social/controller/bottom_controller.dart';
import 'package:flutter/material.dart';
import 'package:light_bottom_navigation_bar/light_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomController>(context, listen: false);

    return Scaffold(
      bottomNavigationBar: LightBottomNavigationBar(
        height: 55,
        currentIndex: provider.index,
        items: makeNavItems(),
        onSelected: (index) {
          provider.value(index);
        
        },
      ),
      body: Consumer<BottomController>(builder: (context, pro, _) {
        return Center(child: pro.screensList[pro.index]);
      }),
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
