import 'package:daily_expense_tracker/modules/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final deleteTx;
  TransactionList(this.transaction, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (ctx, constraint) {
              return Column(
                children: [
                  Text(
                    "No transaction added yet!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: constraint.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemCount: transaction.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FittedBox(
                            child: Text('\$${transaction[index].amount}')),
                      ),
                    ),
                    title: Text(
                      transaction[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transaction[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 360
                        ? TextButton.icon(
                            label: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red.shade800,
                            ),
                            onPressed: () => deleteTx(transaction[index].id),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red.shade800,
                            onPressed: () => deleteTx(transaction[index].id),
                          ),
                  ),
                );
              },
            ),
    );
  }
}
