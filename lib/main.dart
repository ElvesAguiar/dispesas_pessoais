import 'dart:convert';

import 'package:expenses/components/chart.dart';
import 'package:expenses/components/transaction_form.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();

    return MaterialApp(
      home: MyHomePage(),
      theme: tema.copyWith(
        colorScheme: tema.colorScheme.copyWith(
          primary: Colors.purple,
          secondary: Colors.amber,
        ),
        textTheme: tema.textTheme.copyWith(
          headline6: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _baseUrl = 'http://10.0.2.2:8080';
  final List<Transaction> _transactions = [];
  @override
  void initState() {
    super.initState();
    _loadTransactions(); 
  }

  Future<void> _loadTransactions() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/transactions'));

      if (response.statusCode == 200) {
     
        final List<dynamic> decodedData = jsonDecode(response.body);
      
        setState(() {
          _transactions.clear();
          _transactions
              .addAll(decodedData.map((data) => Transaction.fromJson(data)));
        });
      } else {
        print(
            'Erro ao carregar transações. Status code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      print('Erro ao carregar transações: $error');
      print('Stack trace: $stackTrace');
    }
  }

  List<Transaction> get _recentTransaction {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

 _addTransaction(String title, double value, DateTime date) async {
  final newTransaction = Transaction(
    id: Random().nextDouble().toString(),
    title: title,
    value: value,
    date: date,
  );
  print('Executando _addTransaction');

  try {
    final response = await http.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {
        'Content-Type': 'application/json', // Ensure this line is present
      },
      body: jsonEncode(
        {
          "title": newTransaction.title,
          "value": newTransaction.value,
          "date": DateFormat('yyyy-MM-dd').format(newTransaction.date)
        },
      ),
    );

    if (response.statusCode == 201) {
 
      setState(() {
        _transactions.add(newTransaction);
      });

      print(jsonDecode(response.body));
      print('Response status: ${response.statusCode}');
    } else {
      print('Falha ao adicionar transação. Status code: ${response.statusCode}');
    }
  } catch (error, stackTrace) {
    print('Error: $error');
    print('Stack trace: $stackTrace');
  }

  Navigator.of(context).pop();
}

  _deleteTransaction(String id) async{

    try {
    final response = await http.delete(
      Uri.parse('$_baseUrl/transactions'+'/${id}'),
      
    );

    if (response.statusCode == 204) {
 
      setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
    });

      print(jsonDecode(response.body));
      print('Response status: ${response.statusCode}');
    } else {
      print('Falha ao deletar transação. Status code: ${response.statusCode}');
    }
  } catch (error, stackTrace) {
    print('Error: $error');
    print('Stack trace: $stackTrace');
  }
    
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return TransactionForm(_addTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Despesas Pessoais'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openTransactionFormModal(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Chart(_recentTransaction),
            TransactionList(_transactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _openTransactionFormModal(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
