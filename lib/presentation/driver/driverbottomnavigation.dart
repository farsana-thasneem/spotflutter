import 'package:flutter/material.dart';
import 'package:trackmybus/presentation/driver/addAlert.dart';
import 'package:trackmybus/presentation/driver/viewBlockScreen.dart';

class DriverNavigation extends StatefulWidget {
  const DriverNavigation({super.key});

  @override
  State<DriverNavigation> createState() => _DriverNavigationState();
}

class _DriverNavigationState extends State<DriverNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ViewBlockScreen(),

    const AddAlertScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(184, 28, 55, 25),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.block), label: "Block Info"),

          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: "Add Alert",
          ),
        ],
      ),
    );
  }
}
