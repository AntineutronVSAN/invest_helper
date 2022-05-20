import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invests_helper/parts/tab_navigator.dart';
import 'package:invests_helper/theme/ui_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invest helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[

    TabNavigator.getHomePage(),
    TabNavigator.getCryptoMainPage(),
    TabNavigator.getFiatPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          _widgetOptions[0],
          _widgetOptions[1],
          _widgetOptions[2],
        ],
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.secondColor,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/crypto_currency.svg',
              width: 25,
              height: 25,
              color: AppColors.primaryColor,
            ),
            label: 'Крипта',
            backgroundColor: AppColors.primaryColor,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: 'Валюта',
            backgroundColor: AppColors.primaryColor,
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.secondTextColor,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}