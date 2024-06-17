import 'package:expenses_tracker/data/expense_data.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  ExpenseTile(
      {super.key,
      required this.name,
      required this.amount,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.black.withOpacity(0.8),
          title: Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            dateTime.day.toString() +
                ' / ' +
                dateTime.month.toString() +
                ' / ' +
                dateTime.year.toString(),
            style: TextStyle(color: Colors.white),
          ),
          trailing: Text(
            amount + 'XOF',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.delete),
            onPressed: () {
              Provider.of<ExpenseData>(context, listen: false)
                  .deleteAnExpense(name);
            },
          ),
        ),
        SizedBox(
          height: 23,
        ),
      ],
    );
  }
}
