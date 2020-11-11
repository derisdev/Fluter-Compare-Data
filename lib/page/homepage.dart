import 'package:flutter_assignment/page/my_custom_form.dart';
import 'package:flutter_assignment/page/csv_input.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  DateTime currentBackPressTime;
  
  final pages = [
    MyCustomForm(),
    CSVInput(),
  ];

  int selectedIndex = 0;

  void onTap(int index) {
    setState(() {
      selectedIndex = index;
 });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text('Assignment')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            title: Text('CSV Input')
          ),
        ],
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.blue,    
        unselectedItemColor: Colors.grey.withOpacity(0.7),   
        onTap: onTap,
      ),
      body: pages.elementAt(selectedIndex),
    );
  }
}