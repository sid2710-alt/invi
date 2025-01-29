import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invi/models/invoice.dart';
import 'package:invi/utils/secure_storage.dart';

class InvoiceApi {
  static const String apiUrl =
      'http://localhost:8081/api/invoices'; // Your actual API URL
  static const String loginUrl = 'http://localhost:8081/auth';

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

  static Future<String> login(String username, String password) async {
    final http.Response response = await http.post(
      Uri.parse('$loginUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final String token = response.body;
      await SecureStorage.instance.storeToken(token);
      return token;
    } else {
      throw Exception(response.body);
    }
  }

  static Future<String> register(String username, String password) async {
    final http.Response response = await http.post( 
      Uri.parse('$loginUrl/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final String token = response.body;
      return token;
    } else {
      throw Exception(response.body);
    }
  }
}
