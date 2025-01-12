import 'package:invi/models/Item.dart';

class Invoice {
  final int id;
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

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      clientName: json['clientName'],
      date: DateTime.parse(json['date']),
      items: (json['items'] as List)
          .map((itemJson) => InvoiceItem.fromJson(itemJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  Invoice copyWith({
    int? id,
    String? clientName,
    DateTime? date,
    List<InvoiceItem>? items,
  }) {
    return Invoice(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      date: date ?? this.date,
      items: items ?? this.items,
    );
  }
}
