import 'package:al_ameen/Search_page.dart';
import 'package:al_ameen/account_page.dart';
import 'package:al_ameen/add_details_page.dart';
import 'package:al_ameen/analytics_page.dart';
import 'package:al_ameen/transaction_page.dart';
import 'package:al_ameen/transactions_page.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _pages = const [
    TransactionPage(),
    SearchPage(),
    // AddDetailsPage(),
    AnalyticsPage(),
    AccountPage()
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

      //     BottomNavigationBar(
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: _selectedIndex,
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //       _tabController.index = _selectedIndex;
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       // backgroundColor: Colors.transparent,
      //       icon: SizedBox(),
      //       label: '',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.analytics),
      //       label: 'Analytics',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Account',
      //     ),
      //   ],
      // ),

      floatingActionButton: FabWidget(),
      // OpenContainer(
      //   transitionDuration: Duration(seconds: 2),
      //   openBuilder: (context, _) => const AddDetailsPage(),
      //   closedShape: const CircleBorder(),
      //   closedBuilder: (context, action) => FloatingActionButton(
      //     elevation: 0,
      //     onPressed: () => action,
      //     // Navigator.of(context).push(
      //     //     MaterialPageRoute(builder: (context) => const AddDetailsPage())),
      //     child: const Icon(Icons.add),
      //   ),
      // ),
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
