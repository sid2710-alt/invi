class InvoiceItem {
  final String name;
  final int quantity;
  final double unitPrice;

  InvoiceItem({required this.name, required this.quantity, required this.unitPrice});

  double get totalPrice => quantity * unitPrice;
}
