import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/listsScreen/lists.dart';
import 'package:capstone_anesi/productScreen/product.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  // Define cartItems as a stateful list
  List<Map<String, dynamic>> cartItems = [];

  // Screens list that includes the cartItems
  late final List<Widget> screens;  

  @override
  void initState() {
    super.initState();

    // Initialize screens with cartItems being passed to the Carts screen
    screens = [
      const Product(),
      const Carts(),
      const ListScreen(),
    ];
  }

  void addToCart(Map<String, dynamic> item) {
    setState(() {
      cartItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        height: 80,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildNavItem(Icons.dashboard_rounded, 'Products', 0),
            buildNavItem(Icons.shopping_cart, 'Cart', 1),
            buildNavItem(Icons.receipt_long_rounded, 'Payment', 2),
          ],
        ),
      ),
      body: screens[currentIndex],
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: currentIndex == index ? kprimaryColor : Colors.grey.shade400,
          ),
          Text(
            label,
            style: TextStyle(
              color:
                  currentIndex == index ? kprimaryColor : Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
