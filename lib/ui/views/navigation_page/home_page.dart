import 'package:al_ameen/ui/views/account_page/account_page.dart';
import 'package:al_ameen/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen/ui/views/analytics_page/analytics_page.dart';
import 'package:al_ameen/ui/views/search_page/search_page.dart';
import 'package:al_ameen/ui/views/transactions_page/transaction_page.dart';
import 'package:al_ameen/utils/shared_preference.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.sharedPref, {super.key});
  final SharedPreferencesServices sharedPref;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [
    const TransactionPage(
      key: Key('transactions'),
    ),
    const SearchPage(),
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
      floatingActionButton:  FabWidget(widget.sharedPref),
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
    final isTablet = SizerUtil.deviceType == DeviceType.tablet;
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        key: Key('add-details'),
        icon: Icon(
          Icons.no_cell,
        ),
        onPressed: null,
      ),
    );
    return BottomAppBar(
      padding: EdgeInsets.symmetric(vertical: isTablet ? 0.5.h : 0.3.h),
      shape: const CircularNotchedRectangle(),
      notchMargin: isTablet ? 3.sp : 5.sp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildTabItem(
              key: const Key('transaction'),
              icon: const Icon(Icons.home),
              index: 0),
          buildTabItem(
              key: const Key('search'),
              icon: const Icon(Icons.search),
              index: 1),
          placeholder,
          buildTabItem(
              key: const Key('analytics'),
              icon: const Icon(Icons.analytics),
              index: 2),
          buildTabItem(
              key: const Key('accounts'),
              icon: const Icon(Icons.person),
              index: 3),
        ],
      ),
    );
  }

  buildTabItem({required Key key, required Icon icon, required int index}) {
    final isTablet = SizerUtil.deviceType == DeviceType.tablet;

    final selectedColor = index == this.index;
    return IconTheme(
      key: key,
      data: IconThemeData(
          color: selectedColor ? Colors.blue : Colors.grey,
          size: isTablet ? 12.sp : 15.sp),
      child: IconButton(
        icon: icon,
        onPressed: () => onchanged(index),
      ),
    );
  }
}

class FabWidget extends StatelessWidget {
  const FabWidget(this.sharedPref, {super.key});
  final SharedPreferencesServices sharedPref;

  @override
  Widget build(BuildContext context) {
    final isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return OpenContainer(
      key: const Key('open_add_details_page'),
      transitionDuration: const Duration(seconds: 1),
      closedShape: const CircleBorder(),
      closedColor: Theme.of(context).primaryColor,
      openColor: Theme.of(context).primaryColor,
      openBuilder: (context, action) =>
          AddDetailsPage(sharedPref.checkLoginStatus()),
      closedBuilder: (context, action) => Container(
        height: 6.h,
        width: 6.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: isTablet ? 12.sp : 15.sp,
        ),
      ),
    );
  }
}
