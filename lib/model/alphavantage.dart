import 'dart:convert';
import 'package:http/http.dart' as http;

class AlphavantageApi {
  static const String baseUrl = 'https://www.alphavantage.co/query';
  static const String apiKey = 'XM7UM38AOT31Q27X';

  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final url = Uri.parse('$baseUrl?function=SYMBOL_SEARCH&keywords=$symbol&apikey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data =  json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> getDetailStockData(String symbol) async {
    final url = Uri.parse('$baseUrl?function=GLOBAL_QUOTE&symbol=$symbol&apikey=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data =  json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }
}