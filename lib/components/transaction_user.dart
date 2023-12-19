import 'dart:math';

import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'transaction_list.dart';

class TransactionUser extends StatefulWidget {
  @override
  State<TransactionUser> createState() => _TransactionUserState();
}

class _TransactionUserState extends State<TransactionUser> {
  final _transactions = [
    Transaction(
      't1',
      'Novo Tênis de Corrida',
      310.76,
      DateTime.now(),
    ),
    Transaction(
      't2',
      'Conta de Luz#1',
      211.30,
      DateTime.now(),
    ),
     Transaction(
      't3',
      'Conta de Luz#2',
      211.30,
      DateTime.now(),
    ),
     Transaction(
      't4',
      'Conta de Luz#3',
      211.30,
      DateTime.now(),
    ),  Transaction(
      't5',
      'Conta de Luz#4',
      211.30,
      DateTime.now(),
    ),
       Transaction(
      't6',
      'Conta de Luz#5',
      211.30,
      DateTime.now(),
    ),
  ];

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      Random().nextDouble().toString(),
      title,
      value,
      DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionForm(_addTransaction),
        TransactionList(_transactions),
      ],
    );
  }
}
