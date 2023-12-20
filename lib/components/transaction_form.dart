import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double) onSummit;

  TransactionForm(this.onSummit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();

  final valueController = TextEditingController();

  _summitForm() {
                  final title = titleController.text;
                  final value = double.tryParse(valueController.text) ?? 0.0;

                  if(title.isEmpty || value <=0){
                    return;
                  }
                  widget.onSummit(title, value);
                }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          TextField(
            controller: titleController,
            onSubmitted: (_) => _summitForm(),
            decoration: InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: valueController,
            onSubmitted: (_) => _summitForm(),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: 'Valor (R\$)'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton(
                onPressed: _summitForm,
                child: Text('Nova Transação'),
                textColor: Colors.purple,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
