import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invi/models/invoice.dart';

class InvoiceApi {
  static const String apiUrl =
      'http://localhost:8081/api/invoices'; // Your actual API URL

  static Future<int> saveInvoice(Invoice invoice) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(invoice.toJson()),
      );

      if (response.statusCode == 201) {
        final String invoiceId = response.body;
        return int.parse(invoiceId);
      } else {
        throw Exception('Failed to save invoice');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Invoice>> fetchInvoices() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((data) => Invoice.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch invoices');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> deleteInvoice(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete invoice');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<int> updateInvoice(Invoice invoice) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${invoice.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(invoice.toJson()),
    );

    if (response.statusCode == 200) {
      final String invoiceId = response.body;
      return int.parse(invoiceId);
    } else {
      throw Exception('Failed to Update invoice');
    }
  }
}
