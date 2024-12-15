class Invoice {
  final String id;
  final String clientName;
  final double amount;
  final DateTime date;

  Invoice({
    required this.id,
    required this.clientName,
    required this.amount,
    required this.date,
  });
}