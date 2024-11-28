import 'package:capstone_anesi/cartScreen/cartmodel.dart';
import 'package:capstone_anesi/inventoryScreen/inventorymodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_anesi/cartScreen/cart.dart';
import 'package:capstone_anesi/constant.dart';

class Noodles extends StatefulWidget {
  const Noodles({super.key});

  @override
  _NoodlesState createState() => _NoodlesState();
}

class _NoodlesState extends State<Noodles> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allItems = [
    {'name': 'Cheesy Spicy Samyang Noodles', 'price': 150.00, 'category': 'SOLO', 'minMeltedCheese': 35,
    'minCSN': 1},

    {'name': 'Cheesy Spicy Samyang Carbonara', 'price': 150.00, 'category': 'SOLO', 'minMeltedCheese': 35,
    'minCSC': 1},

    {'name': 'Cheesy Samyang Noodles', 'price': 150.00, 'category': 'SOLO', 'minMeltedCheese': 35,
    'minCN': 1},

    {'name': 'Cheesy Spicy Samyang Noodles (Sharing)', 'price': 299.00, 'category': 'SHARING', 
    'minMeltedCheese': 70,'minCSN': 2},

    {'name': 'Cheesy Spicy Samyang Carbonara (Sharing)', 'price': 299.00, 'category': 'SHARING', 
    'minMeltedCheese': 70,'minCSC': 2},

    {'name': 'Cheesy Samyang Noodles (Sharing)', 'price': 299.00, 'category': 'SHARING', 
    'minMeltedCheese': 70,'minCN': 2},
    // ADD ONS
    {'name': 'Egg', 'price': 25.00, 'category': 'ADD-ONS', 'minEgg': 1},
    {'name': 'Spam Slice', 'price': 30.00, 'category': 'ADD-ONS', 'minSpam': 1},
    {'name': 'Chicken Karaage (3pcs)', 'price': 50.00, 'category': 'ADD-ONS', 'minKaraage': 3},
    {'name': 'Extra Cheese Sauce', 'price': 40.00, 'category': 'ADD-ONS', 'minMeltedCheese': 35},
    {'name': 'Nori', 'price': 20.00, 'category': 'ADD-ONS', 'minNori': 1},
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
        title: const Text('Noodles'),
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
                  _buildSection('SOLO'),
                  const SizedBox(height: 35),
                  _buildSection('SHARING'),
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
                            Text(
                                'Total: ${cartModel.totalPrice.toStringAsFixed(2)}'),
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
            childAspectRatio: 1.5,
          ),
          itemCount: categoryItems.length,
          itemBuilder: (context, index) {
            final item = categoryItems[index];
            return CoffeeCard(
              name: item['name'], 
              price: item['price'],
              minMeltedCheese: item['minMeltedCheese'] ?? 0,
              minCSN: item['minCSN'] ?? 0,
              minCSC: item['minCSC'] ?? 0,
              minCN: item['minCN'] ?? 0,
              minEgg: item['minEgg'] ?? 0,
              minSpam: item['minSpam'] ?? 0,
              minKaraage: item['minKaraage'] ?? 0,
              minNori: item['minNori'] ?? 0,
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
  final int minMeltedCheese;
  final int minCSN;
  final int minCSC;
  final int minCN;
  final int minEgg;
  final int minSpam;
  final int minKaraage;
  final int minNori;

   const CoffeeCard({
    super.key,
    required this.name,
    required this.price, 
    this.minMeltedCheese = 0, 
    this.minCSN = 0, this.minCSC = 0,this.minCN =  0,
    this.minEgg = 0,this.minSpam = 0,this.minKaraage = 0,this.minNori = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kprimaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15),
          Text(
            price.toStringAsFixed(2),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () {
              Provider.of<CartModel>(context, listen: false).addToCart(name, price); 
              
              Provider.of<InventoryModel>(context, listen: false).deductItem('Melted Cheese',minMeltedCheese);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Cheesy Spicy Samyang Noodles',minCSN);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Cheesy Spicy Samyang Carbonara',minCSC);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Cheesy Samyang Noodles',minCN);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Egg',minEgg);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Spam',minSpam);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Chicken Karaage',minKaraage);
              Provider.of<InventoryModel>(context, listen: false).deductItem('Nori',minNori);
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 11, 91, 78),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

