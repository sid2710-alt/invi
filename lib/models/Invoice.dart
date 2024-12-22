import 'package:invi/models/Item.dart';

class Invoice {
  final String id;
  final String clientName;
  final DateTime date;
  final List<InvoiceItem> items;

  Invoice({
    required this.id,
    required this.clientName,   
    required this.date,
    required this.items,
  });

  double get totalAmount => items.fold(0, (sum, item) => sum + item.totalPrice);
}
