import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:second_app/models/transaction.dart';
import 'package:second_app/widgets/chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  //this whole is from tutorial but there probably can be less heavy and more easy to read solution
  //getter, creates value dynamically, here we need less code to create variable groupedTransactionValues with getter, also this value can be different each time we start application (if we would have DB)
  List<Map<String, Object>> get groupedTransactionValues {
    //here we are generating new map that will have 7 entries
    return List.generate(7, (index) {
      //here on this crazy line we just getting, on each iteration next day in week(Monday, Wednesday...)
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;

      //here we finding transactions for particular week day
      //lets say that we have index zero, so weekDay = Monday, this year and moth, if we find any transaction from weekDay we add that transaction amount to totalSum
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      //here in day we receive weekday (for example Monday), and that function makes form Monday just M
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
                //with this widget you can distribute space in row and column
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      label: data['day'] as String,
                      spendingAmount: data['amount'] as double,
                      //because if none transactions are created, totalSPending is zero and then we divide by 0 which trows an error
                      spendingPercentOfTotal: totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending),
                );
              }).toList(),
            ),
          )),
    );
  }
}
