class InvoiceItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final String? description;

  InvoiceItem({required this.name, required this.quantity, required this.unitPrice, this.description});

  double get totalPrice => quantity * unitPrice;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: json['price'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': unitPrice,
      'description': description,
    };
  }
}
