import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/create/screens/create_options_screen.dart';
import 'package:pinterest_clone/features/home/screens/home_screen.dart';
import 'package:pinterest_clone/features/profile/screens/profile_screen.dart';
import 'package:pinterest_clone/features/search/screens/search_screen.dart';

class TabScreen extends ConsumerStatefulWidget {
  const TabScreen({super.key});

  @override
  ConsumerState<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends ConsumerState<TabScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var activeContent = switch (_selectedIndex) {
      0 => const HomeScreen(),
      1 => const SearchScreen(),
      2 => const Placeholder(),
      3 => const ProfileScreen(),
      _ => const Placeholder(),
    };
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (val) {
              if (val == 2) {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) => ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * .25,
                              child: const CreateOptionsScreen()),
                        ));
              } else {
                setState(() {
                  _selectedIndex = val;
                });
              }
            },
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/home.png')),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ImageIcon(
                      AssetImage('assets/images/magnifying-glass.png')),
                  label: ''),
              BottomNavigationBarItem(
                  icon: ImageIcon(AssetImage('assets/images/plus.png')),
                  label: ''),
              BottomNavigationBarItem(icon: CircleAvatar(), label: ''),
            ]),
        body: activeContent);
  }
}
