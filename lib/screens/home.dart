import 'package:flutter/material.dart';
import 'package:serverapp/models/product.dart';
import 'package:serverapp/services/products_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> produts = [];
  @override
  void initState() {
    // ProductsService.seedInitialProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductsService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          } else {
            final products = snapshot.data!;
            return ListView(
              children: [
                ...products.map((product) => Card(
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text("${product.quantity} items in stock"),
                    trailing: Text('Ksh ${product.price}'),
                  ),
                ))
              ],
            );
          }
        },
      )
    );
  }
}