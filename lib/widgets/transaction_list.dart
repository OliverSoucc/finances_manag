import 'package:flutter/material.dart';
import 'package:second_app/models/transaction.dart';
import 'package:second_app/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: transactions.isEmpty
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  children: [
                    Text(
                      'No transactions are added yet',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                        height: constraints.maxHeight * 0.6,
                        child: Image.asset(
                          'assets/images/waiting.png',
                          fit: BoxFit.cover,
                        )),
                  ],
                );
              })
            : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  return TransactionItem(deleteTransaction: deleteTransaction, transaction: transactions[index],);
                },
              ));
  }
}
