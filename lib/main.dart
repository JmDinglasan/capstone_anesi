import 'package:capstone_anesi/app.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/cartScreen/noodlesModel.dart';
import 'package:capstone_anesi/historyScreen/transactionModel.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:capstone_anesi/listsScreen/lists.dart';
import 'package:capstone_anesi/loginScreen.dart';
import 'package:capstone_anesi/orderModel.dart';
import 'package:capstone_anesi/productScreen/product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CartModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartModelNoodles(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderModel(),
        ),
        ChangeNotifierProvider(create: (_) => TransactionModel()),
        ChangeNotifierProvider(
            create: (_) => InventoryModel(inventorystock: 0)),
      ],
      child: MyApp(),
    ),
  ); //
}

// //eto mula dito hanggang bnaba ipaste nyo sa sa main.dart nyo
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      initialRoute: '/',
      routes: {
        '/product': (context) => const Product(),
        '/cart': (context) => const Carts(),
        '/list': (context) => const ListScreen(),
        'mainscreen': (context) => const MainScreen(),
      },
      home: LoginPage(),
    );
  }
}

