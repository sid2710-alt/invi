import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invi/models/invoice.dart';

class InvoiceApi {
  static const String apiUrl = 'http://yourapiurl.com/api/invoices'; // Your actual API URL

  static Future<int> saveInvoice(Invoice invoice) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'clientName': invoice.clientName,
          'amount': invoice.totalAmount,
          'date': invoice.date.toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
       return 20;
      } else {
        throw Exception('Failed to save invoice');
      }
    } catch (e) {
      rethrow;
    }
  }
}
