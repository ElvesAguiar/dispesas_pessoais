// transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:expenses/models/transaction.dart';

class TransactionService {
  static const _baseUrl = 'http://10.0.2.2:8080';

  TransactionService();

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/transactions'));
      return _handleResponse(response);
    } catch (error, stackTrace) {
      _handleError('Erro ao carregar transações', error, stackTrace);
      throw Exception('Erro ao carregar transações: $error');
    }
  }

  Future<void> addTransaction(String title, double value, DateTime date) async {
    final newTransaction = Transaction(
      id: "",
      title: title,
      value: value,
      date: date,
    );

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          {
            "title": newTransaction.title,
            "value": newTransaction.value,
            "date": DateFormat('yyyy-MM-dd').format(newTransaction.date),
          },
        ),
      );
      _handlePostResponse(response);
    } catch (error, stackTrace) {
      _handleError('Erro ao adicionar transação', error, stackTrace);
      throw Exception('Erro ao adicionar transação: $error');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/transactions/$id'),
      );

      _handleDeleteResponse(response);
    } catch (error, stackTrace) {
      _handleError('Erro ao deletar transação', error, stackTrace);
      throw Exception('Erro ao deletar transação: $error');
    }
  }

  List<Transaction> _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      return decodedData.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception(
          'Erro ao carregar transações. Status code: ${response.statusCode}');
    }
  }

  void _handlePostResponse(http.Response response) {
    if (response.statusCode == 201) {
      print('Transação adicionada com sucesso!');
    } else {
      throw Exception(
          'Falha ao adicionar transação. Status code: ${response.statusCode}');
    }
  }

  void _handleDeleteResponse(http.Response response) {
    if (response.statusCode == 204) {
      print('Transação removida com sucesso!');
    } else {
      throw Exception(
          'Falha ao deletar transação. Status code: ${response.statusCode}');
    }
  }

  void _handleError(String context, Object error, StackTrace stackTrace) {
    print('$context: $error');
    print('Stack trace: $stackTrace');
  }
}
