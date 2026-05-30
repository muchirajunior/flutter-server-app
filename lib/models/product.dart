class Product {
  final int id;
  final String name;
  final num price;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id']  ?? 0,
      name: json['name']  ?? '',
      price: num.tryParse( json['price'].toString()) ?? 0.0,
      quantity: json['quantity']  ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }
}
