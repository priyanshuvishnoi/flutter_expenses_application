import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/adaptive_flat_button.dart';
import 'package:intl/intl.dart';

final platform = Platform.isIOS;

class NewTransaction extends StatefulWidget {
  final addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null)
      return;

    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    platform
        ? showCupertinoModalPopup(
            context: context,
            builder: (_) => Container(
                  height: 300,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            initialDateTime: DateTime.now(),
                            onDateTimeChanged: (val) {
                              setState(() {
                                _selectedDate = val;
                              });
                            }),
                      ),

                      // Close the modal
                      CupertinoButton(
                        child: Text('OK'),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ],
                  ),
                ))
        : showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2021),
            lastDate: DateTime.now(),
          ).then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            setState(() {
              _selectedDate = pickedDate;
            });
          });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: platform
                ? [
                    CupertinoTextField(
                      placeholder: 'Title',
                      onSubmitted: (_) => _submitData(),
                      controller: _titleController,
                    ),
                    SizedBox(height: 10),
                    CupertinoTextField(
                      placeholder: 'Amount',
                      onSubmitted: (_) => _submitData(),
                      controller: _amountController,
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_selectedDate == null
                                ? 'No Date Chosen'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                          ),
                          AdaptiveFlatButton('Choose Date', _presentDatePicker)
                        ],
                      ),
                    ),
                    Center(
                      child: CupertinoButton(
                        onPressed: _submitData,
                        child: Text("Add transaction"),
                        color: Theme.of(context).primaryColor,
                        // textColor: Theme.of(context).textTheme.button.color,
                      ),
                    )
                  ]
                : [
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      onSubmitted: (_) => _submitData(),
                      controller: _titleController,
                      // onChanged: (value) => titleInput = value,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Amount'),
                      controller: _amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submitData(),
                      // onChanged: (value) => amountInput = value,
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(_selectedDate == null
                                ? 'No Date Chosen'
                                : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                          ),
                          AdaptiveFlatButton('Choose Date', _presentDatePicker)
                        ],
                      ),
                    ),
                    RaisedButton(
                      onPressed: _submitData,
                      child: Text("Add transaction"),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).textTheme.button.color,
                    )
                  ],
          ),
        ),
      ),
    );
  }
}
