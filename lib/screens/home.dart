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

  addProduct(){
    bool isLoading = false;
    Product product = Product.fromJson({});
    showDialog(
      context: context, 
      builder: (context)=>StatefulBuilder(
        builder: (context,setState){
          return AlertDialog(
            title: Text('Add item'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Product Name'),
                    onChanged: (value) => product.name = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Price (Ksh)'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => product.price = double.tryParse(value) ?? 0.0,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Quantity in Stock'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => product.quantity = int.tryParse(value) ?? 0,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        setState(() => isLoading = true);
                        await ProductsService.addProduct(product);
                        if (mounted) {
                          Navigator.pop(context);
                          setState(() {}); // Refresh the product list
                        }
                      },
                      child: isLoading 
                          ? const CircularProgressIndicator()
                          : const Text('Add Product'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    ).then((_)=>setState(() { }));
  }

  @override
  void initState() {
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
            return RefreshIndicator(
              onRefresh: () async=> setState(() {  }),
              child: ListView(
                children: [
                  ...products.map((product) => Card(
                    child: ListTile(
                      title: Text(product.name),
                      subtitle: Text("${product.quantity} items in stock"),
                      trailing: Text('Ksh ${product.price}'),
                    ),
                  ))
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: addProduct, child: Icon(Icons.add),),
    );
  }
}