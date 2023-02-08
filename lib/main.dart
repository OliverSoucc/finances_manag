import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:second_app/widgets/chart.dart';
import 'package:second_app/widgets/new_transaction.dart';
import 'package:second_app/widgets/transaction_list.dart';

import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal finances',
      theme: ThemeData(
          //you can add fonts in pubspec.yaml at the end, name we putted here have to match the name in -->  - family: Quicksand
          fontFamily: 'Quicksand',
          //here we setting global color, so if we want to change the theme of our application, we need to change it just one place
          //you can access this color like -> color: Theme.of(context).primaryColor
          primarySwatch: Colors.purple,
          //basically secondary color
          accentColor: Colors.amber,
          //setting global style for all text in app
          textTheme: const TextTheme(
            //here we just setting all titles
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          //global style for AppBar(in this case just for AppBar title)
          appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    Transaction(id: '1', title: 'New Shoes', amount: 9.50, date: DateTime.now()),
    Transaction(id: '2', title: 'Toothbrush', amount: 3.20, date: DateTime.now()),
    Transaction(id: '3', title: 'Pele', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '4', title: 'Loko', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '5', title: 'Jano', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '6', title: 'Milos', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '7', title: 'Mato', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '8', title: 'Fejker', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '2', title: 'Exodus', amount: 3.20, date: DateTime.now()),
    // Transaction(id: '2', title: 'Oprah', amount: 3.20, date: DateTime.now()),
  ];

  /////////////////just for showing purposes
  @override
  void initState() {
    //whenever my lifecycle changes, addObserver and go didChangeAppLifecycleState method
    //this keyword means, this class
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  //comes from WidgetsBindingObserver
  //you need to have initState() and dispose() with didChangeAppLifecycleState() to be efficient
  @override
  didChangeAppLifecycleState(AppLifecycleState state){
    //here we are accessing the App lifecycle (Notion-> Lifecycle)
    //what we can see in print, for example inactive and paused -> when app is still running but we are using different app (or we are on home page or somewhere else), resume when we come back to running app and so on
    print(state);
  }

  @override
  dispose(){
    //then we need to get rid of our observer when this state object should be removed (when app is shutdown)
    //to avoid memory leaks
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
  ///////////////////////////////////////////////////////////

  //this getter we created because we want to include in chart just transactions from current week
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList(); //Add toList() here
  }

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: date);
    setState(() {
      _userTransactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    //function from flutter that creates modal window
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Show Chart'),
        //.adaptive() renders native switch for android and IOS
        Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (value) {
              setState(() {
                _showChart = value;
              });
            })
      ],
    );
  }

  Widget _buildPortraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar) {
    return Container(
      //this is nessesary, because rotate our phone to landscape, and start to scroll the list of transactions, we will not be able to chart if we scroll back up, because previousli height was set to 450px
      //not it is set to 60 visible screen (in CSS 60vh)
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: Chart(_recentTransactions),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTransaction(context))
              ],
            ))
        : AppBar(
            title: const Text(
              'Personal finances',
              style: TextStyle(fontFamily: 'Open Sans'),
            ),
            //actions -> A list of Widgets to display in a row after the title widget
            //actions -> Typically these widgets are IconButtons representing common operations. For less common operations, consider using a PopupMenuButton as the last action.
            actions: [
              IconButton(
                  onPressed: () => _startAddNewTransaction(context),
                  icon: const Icon(Icons.add))
            ],
          ) as PreferredSizeWidget;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    //this I a great patter for readability
    //i did not implemented this in each place cause I was lazy for that :)
    //when to use: when you widget is too big and I would not make sense to spit it
    //1. you create function in you State class that only returns the part of the widget (like here appBar)
    //2. then inside build() you create variable where you calling the method which returns the widget
    //3. then you you put this variable into your widget where you want to display the widget
    final PreferredSizeWidget appBar = _buildAppBar();

    final transactionListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));

    final pageBody =
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (isLandscape) _buildLandscapeContent(),
      if (!isLandscape) _buildPortraitContent(mediaQuery, appBar),
      if (!isLandscape) transactionListWidget,
      if (isLandscape)
        _showChart
            ? Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: Chart(_recentTransactions),
              )
            : transactionListWidget
    ]);

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody)
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            //here we finding on which device platform application is running
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
