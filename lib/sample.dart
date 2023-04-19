import 'package:al_ameen/page1.dart';
import 'package:al_ameen/page2.dart';
import 'package:al_ameen/page3.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const  MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1;
  final PageController _pageController = PageController();

  final _pages = [
    page1(),
    page2(),
    page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const  Text('My App'),
      ),
      body: PageView(
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _pageController,
          children: _pages // added to display current page by default
          ),
      bottomNavigationBar: 
      NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade100,
            labelTextStyle: MaterialStateProperty.all(
                const TextStyle(fontWeight: FontWeight.w500))),
        child: NavigationBar(
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          //animationDuration: const Duration(seconds: 1),
          height: 60,
          backgroundColor: Colors.grey.shade100,
          selectedIndex: _currentIndex,
          onDestinationSelected: (value) => setState(() {
            _currentIndex = value;
          }),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.analytics), label: 'Analytics')
          ],
        ),
      ),
      
      // floatingActionButton: FloatingActionButton(
      //   //  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   onPressed: () {},
      //   child: Icon(Icons.favorite),
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomSheet: BottomAppBar(
      //   shape: CircularNotchedRectangle(),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       IconButton(
      //         icon: Icon(Icons.home),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 0;
      //           });
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.settings),
      //         onPressed: () {
      //           setState(() {
      //             _currentIndex = 2;
      //           });
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
