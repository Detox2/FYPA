// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatelessWidget {
  void Function(int)? OnTabChange;
  BottomNavBar({super.key, required this.OnTabChange});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(35),
        topRight: Radius.circular(35),
      ),
      child: Container(
        color: Colors.white,
        child: GNav(
          onTabChange: (value) => OnTabChange!(value),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: ' Home',
            ),
            GButton(
              icon: Icons.assignment_outlined,
              text: ' Request',
            ),
            GButton(
              icon: Icons.checklist_outlined,
              text: ' Orders',
            ),
          ],
        ),
      ),
    );
  }
}
