import 'dart:developer';

import 'package:serverapp/models/product.dart';
import 'package:serverapp/utils/utils.dart';

class ProductsService {
  
  static Future<List<Product>> getProducts()async{
    try {
      var data = await Utils.dbClient.then((client)=> client.execute('SELECT * FROM products'));
      if(data.isNotEmpty){
        var products =  data.map((item)=> Product.fromJson(item.toColumnMap())).toList();
        return products;
      }
      return [];
    } catch (e) {
      log(e.toString(), name: 'Get products');
      return [];
    }
  }

  static Future<bool> addProduct(Product product)async{
    try {
      await Utils.dbClient.then((client) => client.execute(
            r'INSERT INTO products (name, price, quantity) VALUES($1, $2, $3)',
            parameters: [product.name,product.price, product.quantity],
          ));
      return true;
    } catch (e) {
      log(e.toString(), name: 'Insert products');
      return false;
    }
  }


  static Future<void> createProductsTable() async {
    try {
      await Utils.dbClient.then((client) => client.execute('''
        CREATE TABLE IF NOT EXISTS products (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255) NOT NULL,
          price DECIMAL(10,2) NOT NULL DEFAULT 0.0,
          quantity INTEGER NOT NULL DEFAULT 0
        );
      '''));
      log('Products table created successfully', name: 'Create products table');
    } catch (e) {
      log(e.toString(), name: 'Create products table');
    }
  }

  static Future<void> seedInitialProducts() async {
    try {
      // Check if products table is empty before seeding
      final countResult = await Utils.dbClient.then((client) => 
        client.execute('SELECT COUNT(*) FROM products')
      );
      final count = countResult.first[0] as int;
      
      if (count == 0) {
        final List<Product> initialProducts = [
          Product(id: 0, name: 'Wireless Headphones', price: 79.99, quantity: 50),
          Product(id: 0, name: 'Portable Charger', price: 29.99, quantity: 100),
          Product(id: 0, name: 'Bluetooth Speaker', price: 49.99, quantity: 35),
        ];

        for (final product in initialProducts) {
          await addProduct(product);
        }
        log('Initial products seeded successfully', name: 'Seed products');
      } else {
        log('Products table already has data, skipping seeding', name: 'Seed products');
      }
    } catch (e) {
      log(e.toString(), name: 'Seed products');
    }
  }
}