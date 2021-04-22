import 'package:daily_expense_tracker/widgets/chart.dart';
import 'package:daily_expense_tracker/widgets/new_transaction.dart';
import 'package:daily_expense_tracker/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

import 'modules/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
                fontFamily: 'Open Sans', fontWeight: FontWeight.bold)),
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple,
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      title: "Flutter App",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transaction = [];
  List<Transaction> get _recentTransaction {
    return _transaction.where((element) {
      return element.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime choosenDate) {
    final tx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: choosenDate,
        id: DateTime.now().toString());
    setState(() {
      _transaction.add(tx);
    });
  }

  void startAddNewTransaction(BuildContext tx) {
    showModalBottomSheet(
      context: tx,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(
            addNewTx: _addNewTransaction,
          ),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  bool showChart = false;
  void deleteTransaction(String id) {
    setState(() {
      _transaction.removeWhere(
        (element) => element.id == id,
      );
    });
  }

  List<Widget> _buildLandscapeContent(MediaQueryData mediaQuery, AppBar appBar, Widget txtListWidget) {
    return [Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Switch(
            value: showChart,
            onChanged: (val) {
              setState(() {
                showChart = val;
              });
            })
      ],
    ),showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransaction),
                    )
                  : txtListWidget,];
  }

  List<Widget> _buildPortraitContent(MediaQueryData mediaQuery, AppBar appBar, Widget txtListWidget) {
    return [Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.3,
      child: Chart(_recentTransaction),
    ),txtListWidget];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Expense Tracker"),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );
    final txtListWidget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(
        _transaction,
        deleteTransaction,
      ),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar, txtListWidget),
            if (!isLandscape) ..._buildPortraitContent(mediaQuery, appBar, txtListWidget),
            // if (!isLandscape) ,
            // if (isLandscape)
              
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
