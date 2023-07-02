import 'package:al_ameen/Search_page.dart';
import 'package:al_ameen/account_page.dart';
import 'package:al_ameen/add_details_page.dart';
import 'package:al_ameen/analytics_page.dart';
import 'package:al_ameen/transaction_page.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [
    TransactionPage(),
    const SearchPage(),
    // AddDetailsPage(),
    const AnalyticsPage(),
    const AccountPage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavBar(
        index: _selectedIndex,
        onchanged: onChangedTab,
      ),
      floatingActionButton: const FabWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  onChangedTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class NavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onchanged;
  const NavBar({super.key, required this.index, required this.onchanged});

  @override
  Widget build(BuildContext context) {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        icon: Icon(
          Icons.no_cell,
        ),
        onPressed: null,
      ),
    );
    return BottomAppBar(
      //color: Colors.black,
      //surfaceTintColor: Colors.black,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTabItem(icon: const Icon(Icons.home), index: 0),
          buildTabItem(icon: const Icon(Icons.search), index: 1),
          placeholder,
          buildTabItem(icon: const Icon(Icons.analytics), index: 2),
          buildTabItem(icon: const Icon(Icons.person), index: 3),
        ],
      ),
    );
  }

  buildTabItem({required Icon icon, required int index}) {
    final selectedColor = index == this.index;
    return IconTheme(
      data: IconThemeData(color: selectedColor ? Colors.blue : Colors.grey),
      child: IconButton(
        icon: icon,
        onPressed: () => onchanged(index),
      ),
    );
  }
}

class FabWidget extends StatelessWidget {
  const FabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      //middleColor: Colors.black,
      transitionDuration: const Duration(seconds: 1),
      closedShape: const CircleBorder(),
      closedColor: Theme.of(context).primaryColor,
      openColor: Theme.of(context).primaryColor,
      openBuilder: (context, action) => const AddDetailsPage(),
      closedBuilder: (context, action) => Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
