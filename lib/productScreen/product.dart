import 'package:capstone_anesi/productScreen/categories/coffee.dart';
import 'package:capstone_anesi/productScreen/categories/noodles.dart';
import 'package:capstone_anesi/productScreen/categories/snacks.dart';
import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Product Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              // Categories
              Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              // Categories Column with padding on each card
              Column(
                children: [
                  Center(
                    child: CategoryCard('DRINKS', 'assets/drinks.png', Coffee()),
                  ),
                  Center(
                    child: CategoryCard('NOODLES', 'assets/noodles.png', Noodles()),
                  ),
                  Center(
                    child: CategoryCard('MEALS / SNACKS', 'assets/snacks.png', Snacks()),
                  ),
                ],
              ),
              SizedBox(height: 16), // Added some space at the end
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Widget nextScreen;

  const CategoryCard(this.title, this.imagePath, this.nextScreen, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75, // Adjusted width to 90% of screen width
        margin: const EdgeInsets.symmetric(vertical: 8.0), // Space between cards
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 200, // Adjusted height for a smaller card
                width: double.infinity,
              ),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   height: 120,
            //   // decoration: BoxDecoration(
            //   //   color: const Color(0xFF1A3C40).withOpacity(0.7), // Overlay color with opacity
            //   //   borderRadius: BorderRadius.circular(15),
            //   // ),
            //   child: Text(
            //     title,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
