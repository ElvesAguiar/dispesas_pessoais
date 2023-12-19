import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';
import 'transaction_form.dart';
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
      'Conta de Luz',
      211.30,
      DateTime.now(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TransactionList(_transactions),
        TranasctionForm(),
      ],
    );
  }
}
