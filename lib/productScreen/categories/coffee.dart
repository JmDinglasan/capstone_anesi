import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';

class Coffee extends StatefulWidget {
  const Coffee({super.key});

  @override
  _CoffeeState createState() => _CoffeeState();
}

class _CoffeeState extends State<Coffee> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> allItems = [
    {'name': 'Snickers Iced Coffee', 'price': 130.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minCaramel': 40, 'minSweetener': 30, 'minChoco': 20, 'minIce': 15, 'minMilk': 200},
    
    {'name': 'Marshmallow Iced Coffee', 'price': 130.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minWhiteChoco': 15, 'minIce': 15, 'minMilk': 150},
    
    {'name': 'Spanish Latte', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minSweetener': 40, 'minIce': 15, 'minMilk': 300 },
    
    {'name': 'White Mocha', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minWhiteChoco': 20, 'minIce': 15, 'minMilk': 150},
    
    {'name': 'Double Caramel Macchiato', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minVanilla': 20, 'minIce': 15, 'minMilk': 80, 'minCaramel': 40},
    
    {'name': 'Marble Macchiato', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minChoco': 40, 'minIce': 15, 'minMilk': 200},

    {'name': 'Anesi Iced Coffee', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minVanilla': 20, 'minIce': 15, 'minMilk': 80, 'minCaramel': 40},

    {'name': 'Ube Iced Coffee', 'price': 120.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minUbe': 70, 'minIce': 15, 'minMilk': 150},

    {'name': 'Caramel White Mocha', 'price': 110.00, 'category': 'COFFEE', 'minCoffee': 200, 
    'minWhiteChoco': 10, 'minIce': 15, 'minMilk': 150, 'minCaramel': 40},

    {'name': 'Iced Mocha', 'price': 100.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minChoco': 60, 'minIce': 15, 'minMilk': 150},

    {'name': 'Iced Vanilla Latte', 'price': 95.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minVanilla': 40, 'minIce': 15, 'minMilk': 300},

    {'name': 'Iced Cappuccino', 'price': 90.00, 'category': 'COFFEE', 'minCoffee': 150, 
    'minSweetener': 20, 'minIce': 15, 'minMilk': 200},

    {'name': 'Iced Cafe Latte', 'price': 85.00, 'category': 'COFFEE', 'minCoffee': 150, 
     'minIce': 15, 'minMilk': 300},

    {'name': 'Iced Strong Black Coffee', 'price': 80.00, 'category': 'COFFEE', 'minCoffee': 200, 'minIce': 20},

    {'name': 'White Choco Ube Milk', 'price': 130.00, 'category': 'NON-COFFEE', 'minWhiteChoco': 20, 
     'minIce': 15, 'minMilk': 300, 'minUbe': 20},

    {'name': 'Strawberry Choco', 'price': 110.00, 'category': 'NON-COFFEE', 'minStrawberry': 80, 
    'minIce': 15, 'minMilk': 300,},
    
    {'name': 'Ube Milk', 'price': 110.00, 'category': 'NON-COFFEE', 'minUbe': 50, 
    'minIce': 15, 'minMilk': 300,},

    {'name': 'Anesi Iced Choco', 'price': 100.00, 'category': 'NON-COFFEE', 'minChoco': 80, 
    'minIce': 15, 'minMilk': 300,},

    {'name': 'Strawberry Milk', 'price': 100.00, 'category': 'NON-COFFEE', 'minStrawberry': 50, 
    'minIce': 15, 'minMilk': 300, 'minSweetener': 30},

    {'name': 'Vanilla Milk', 'price': 90.00, 'category': 'NON-COFFEE', 'minVanilla': 40, 
    'minIce': 15, 'minMilk': 300,},

    {'name': 'Caramel Drizzle', 'price': 20.00, 'category': 'ADD-ONS', 'minCaramel': 40},
    {'name': 'Chocolate Drizzle', 'price': 20.00, 'category': 'ADD-ONS', 'minChoco': 40},
    {'name': 'White Chocolate', 'price': 20.00, 'category': 'ADD-ONS', 'minWhiteChoco': 10},
    {'name': 'Sugar Syrup', 'price': 20.00, 'category': 'ADD-ONS', 'minVanilla':10},
  ];

  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(allItems); // Initially show all items
    _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      filteredItems = allItems
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drinks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Menu...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSection('COFFEE'),
                  const SizedBox(height: 35),
                  _buildSection('NON-COFFEE'),
                  const SizedBox(height: 35),
                  _buildSection('ADD-ONS'),
                ],
              ),
            ),
            Consumer<CartModel>(
              builder: (context, cartModel, child) {
                return cartModel.items.isNotEmpty
                    ? Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.grey[200],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.shopping_cart),
                                const SizedBox(width: 8),
                                Text('${cartModel.items.length} Items'),
                              ],
                            ),
                            Text('Total: ${cartModel.totalPrice.toStringAsFixed(2)}'),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const Carts(),
                                  ),
                                );
                              },
                              child: const Text('Go to Cart'),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String category) {
    final categoryItems =
        filteredItems.where((item) => item['category'] == category).toList();

    if (categoryItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            childAspectRatio: 1.0,  
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CoffeeCard(
              name: item['name'],
              price: item['price'],
              minCoffee: item['minCoffee'] ?? 0,
              minSweetener: item['minSweetener'] ?? 0,
              minMilk: item['minMilk'] ?? 0,
              minCaramel: item['minCaramel'] ?? 0,
              minChoco: item['minChoco'] ?? 0,
              minStrawberry: item['minStrawberry'] ?? 0,
              minUbe: item['minUbe'] ?? 0,
              minWhiteChoco: item['minWhiteChoco'] ?? 0,
              minVanilla: item['minVanilla'] ?? 0,
              minIce: item['minIce'] ?? 0,
            );
          },
        ),
      ],
    );
  }
}

class CoffeeCard extends StatelessWidget {
  final String name;
  final double price;
  final int minCoffee;final int minMilk;final int minChoco;final int minCaramel;final int minStrawberry;
  final int minUbe;final int minVanilla;final int minWhiteChoco;final int minIce;final int minSweetener;

  const CoffeeCard({
    super.key,
    required this.name,
    required this.price, 
    this.minCoffee = 0, this.minMilk = 0, this.minChoco = 0,this.minCaramel =  0,
    this.minStrawberry = 0,this.minUbe = 0,this.minVanilla = 0,this.minWhiteChoco = 0,this.minIce = 0,
    this.minSweetener = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor, // Replace with kprimaryColor if defined
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).addToCart(name, price);

              // Deduct the specified amount of INGREDIENTS from inventory
              Provider.of<InventoryModel>(context, listen: false).deductItem('Coffee',minCoffee);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Milk',minMilk);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Chocolate Syrup',minChoco);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Caramel Syrup',minCaramel);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Strawberry Syrup',minStrawberry);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Ube Syrup',minUbe);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Sweetener',minSweetener);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Vanilla Syrup',minVanilla);
              Provider.of<InventoryModel>(context, listen: false).deductItem('White Chocolate Syrup',minWhiteChoco);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Ice',minIce);
            },
              style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 11, 91, 78),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}