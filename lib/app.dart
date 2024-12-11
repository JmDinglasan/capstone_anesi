import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/hamburgerIcon/adminMenu.dart';
// import 'package:capstone_anesi/cartScreen/cartmodel.dart';
// import 'package:capstone_anesi/cartScreen/noodlesModel.dart';
// import 'package:capstone_anesi/historyScreen/transactionModel.dart';
import 'package:capstone_anesi/hamburgerIcon/superAdminMenu.dart';
import 'package:capstone_anesi/hamburgerIcon/staffMenu.dart';
// import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:capstone_anesi/paymentScreen/payment.dart';
import 'package:capstone_anesi/productScreen/product.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'navbar.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'orderModel.dart'; // Import the OrderModel class
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cart',
      initialRoute: '/',
      routes: {
        '/product': (context) => Product(),
        '/cart': (context) => const Carts(),
        '/list': (context) => const ListScreen(),
        'mainscreen': (context) => const MainScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.mulishTextTheme(),
      ),
      home: const MainScreen(),
    );
  }
}

// SUPER ADMIN SCREEN
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anesi POS'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      body: const BottomNavBar(),
    );
  }  
}

class StaffMainScreen extends StatelessWidget {
  const StaffMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anesi POS'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const StaffAppDrawer(),
      body: const BottomNavBar(),
    );
  }  
}

class AdminMainScreen extends StatelessWidget {
  const AdminMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anesi POS'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const AdminAppDrawer(),
      body: const BottomNavBar(),
    );
  }  
}
