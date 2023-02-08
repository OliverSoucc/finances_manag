import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentOfTotal;

  ChartBar(
      {required this.label,
      required this.spendingAmount,
      required this.spendingPercentOfTotal});

  @override
  Widget build(BuildContext context) {
    //mediaQuery vs LayoutBuilder -> mediaQuery gives you device info, LB gives you constraints that apply to a widget
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(children: [
          Container(
            height: constraints.maxHeight * 0.15,
            //to prevent child from expanding, quit the opposite, it should shrink
            child: FittedBox(
              child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            //this widget can stack widgets on top of each other
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label)))
        ]);
      },
    );
  }
}
