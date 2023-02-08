import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//this is stateful widget just because before if you put something in modal widow for example title and then click on amount input, the title text would disappear
//even if we do not use setState() here we needed stateful, because of what I mentioned
//more about this later
class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  NewTransaction(this.addTransaction);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    //you can use widget.something only inside class that extends State<>
    //thanks to this we can access properties from widget class in state class
    widget.addTransaction(enteredTitle, enteredAmount, _selectedDate);

    //this is used to automatically close modal window after we submit
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((pickedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //thanks to this widget we can scroll the form, because keyboard is overlying some fields
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              //viewInsets -> space occupied ny keyboard
              bottom: MediaQuery.of(context).viewInsets.bottom + 10 ,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  controller: _titleController,
                  //here we put underscore because onSubmitted: needs to take anonymous functions with value in parameter, but when you do not use the value parameter it is a good practise to use underscore as parameter name
                  //here we also need to call function with brackets because it is nested inside the anonymous one
                  onSubmitted: (_) => _submitData(),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_selectedDate == null
                          ? 'No date chosen!'
                          : 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'),
                      //these not deprecated buttons have automatically set global styles
                      TextButton(
                          onPressed: _presentDatePicker,
                          child: const Text(
                            'Choose Date',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                //these not deprecated buttons have automatically set global styles
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Add transaction'),
                )
              ],
            )),
      ),
    );
  }
}
