import 'package:expenses_tracker/bar%20graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/datetime/date_time_helper.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

// calculate max amount for graph
  double calculateMax(
    ExpenseData value,
    String sunday,
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
  ) {
    double? max = 100;

    List<double> values = [
      value.calculateDailyExpenseSumary()[sunday] ?? 0,
      value.calculateDailyExpenseSumary()[monday] ?? 0,
      value.calculateDailyExpenseSumary()[tuesday] ?? 0,
      value.calculateDailyExpenseSumary()[wednesday] ?? 0,
      value.calculateDailyExpenseSumary()[thursday] ?? 0,
      value.calculateDailyExpenseSumary()[friday] ?? 0,
      value.calculateDailyExpenseSumary()[saturday] ?? 0,
    ];
    //sort from smallest to the largest
    values.sort();

    //get the largest amount in the end and increase it to avoid mistakes
    max = values.last + 1.1;

    return max == 0 ? 100 : max;
  }

// calculate the week total
  String calculateWeekTotal(
      ExpenseData value,
      String sunday,
      String monday,
      String tuesday,
      String wednesday,
      String thursday,
      String friday,
      String saturday) {
    List<double> values = [
      value.calculateDailyExpenseSumary()[sunday] ?? 0,
      value.calculateDailyExpenseSumary()[monday] ?? 0,
      value.calculateDailyExpenseSumary()[tuesday] ?? 0,
      value.calculateDailyExpenseSumary()[wednesday] ?? 0,
      value.calculateDailyExpenseSumary()[thursday] ?? 0,
      value.calculateDailyExpenseSumary()[friday] ?? 0,
      value.calculateDailyExpenseSumary()[saturday] ?? 0,
    ];

    double total = 0;
    for (int i = 0; i < values.length; i++) {
      total += values[i];
    }

    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    // get yyyymmdd
    String sunday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 0)));
    String monday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 1)));
    String tuesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 2)));
    String wednesday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 3)));
    String thursday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 4)));
    String friday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 5)));
    String saturday =
        convertDateTimeToString(startOfWeek.add(const Duration(days: 6)));

    return Consumer<ExpenseData>(
      builder: (context, value, child) => Column(
        children: [
          //week total
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Week Total Expenses: '),
                Text(
                    '${calculateWeekTotal(value, sunday, monday, tuesday, wednesday, thursday, friday, saturday)} XOF'),
              ],
            ),
          ),

          SizedBox(
            height: 200,
            child: MyBarGraph(
              maxY: calculateMax(value, sunday, monday, tuesday, wednesday,
                  thursday, friday, saturday),
              sunAmount: value.calculateDailyExpenseSumary()[sunday] ?? 0,
              monAmount: value.calculateDailyExpenseSumary()[monday] ?? 0,
              tueAmount: value.calculateDailyExpenseSumary()[tuesday] ?? 0,
              wedAmount: value.calculateDailyExpenseSumary()[wednesday] ?? 0,
              thurAmount: value.calculateDailyExpenseSumary()[thursday] ?? 0,
              friAmount: value.calculateDailyExpenseSumary()[friday] ?? 0,
              satAmount: value.calculateDailyExpenseSumary()[saturday] ?? 0,
            ),
          ),
        ],
      ),
    );
  }
}
