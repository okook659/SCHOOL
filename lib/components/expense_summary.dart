import 'package:expenses_tracker/bar%20graph/bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/datetime/date_time_helper.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class ExpenseSummary extends StatelessWidget {
  final DateTime startOfWeek;
  const ExpenseSummary({super.key, required this.startOfWeek});

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
      builder: (context, value, child) => SizedBox(
        height: 200,
        child: MyBarGraph(
          maxY: 100,
          sunAmount: value.calculateDailyExpenseSumary()[sunday] ?? 0,
          monAmount: value.calculateDailyExpenseSumary()[monday] ?? 0,
          tueAmount: value.calculateDailyExpenseSumary()[tuesday] ?? 0,
          wedAmount: value.calculateDailyExpenseSumary()[wednesday] ?? 0,
          thurAmount: value.calculateDailyExpenseSumary()[thursday] ?? 0,
          friAmount: value.calculateDailyExpenseSumary()[friday] ?? 0,
          satAmount: value.calculateDailyExpenseSumary()[saturday] ?? 0,
        ),
      ),
    );
  }
}
