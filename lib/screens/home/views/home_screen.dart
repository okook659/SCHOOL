import 'dart:math';

import 'package:expenses_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      // ),

      bottomNavigationBar: ClipRect(
        //border Radius
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
                label: 'Home', icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(
                label: 'Stats', icon: Icon(CupertinoIcons.graph_square_fill)),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.tertiary,
                  Theme.of(context).colorScheme.secondary,
                  Theme.of(context).colorScheme.primary,
                ],
                transform: const GradientRotation(pi / 4),
              )),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      body: MainScreen(),
    );
  }
}
