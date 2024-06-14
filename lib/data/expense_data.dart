import 'package:expenses_tracker/datetime/date_time_helper.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overalExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overalExpenseList;
  }

  // add a new expense
  void addNewExpense(ExpenseItem newExpense) {
    overalExpenseList.add(newExpense);

    notifyListeners();
  }

  // delete a new expense
  void deleteExpense(ExpenseItem expense) {
    overalExpenseList.remove(expense);

    notifyListeners();
  }

  // get weekday from a dateTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return "Mon";
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  // get the date for the start of the week ( sunday )
  DateTime startOfWeekDate() {
    DateTime? startOfWeek;

    // get today's date
    DateTime today = DateTime.now();

    // go backwards from today to find sunday
    for (int i = 0; i < 7; i++) {
      if (getDayName(today.subtract(Duration(days: i))) == 'Sun') {
        startOfWeek = today.subtract(Duration(days: i));
      }
    }

    return startOfWeek!;
  }

  /* 
  convert overall list to expenses into a daily expenses summary
  */

  Map<String, double> calculateDailyExpenseSumary() {
    Map<String, double> dailyExpenseSumary = {
      // date
    };

    for (var expense in overalExpenseList) {
      String date = convertDateTimeToString(expense.dateTime);
      double amount = double.parse(expense.amount);

      if (dailyExpenseSumary.containsKey(date)) {
        double currentAmount = dailyExpenseSumary[date]!;
        currentAmount += amount;
        dailyExpenseSumary[date] = currentAmount;
      } else {
        dailyExpenseSumary.addAll({date: amount});
      }
    }

    return dailyExpenseSumary;
  }
}
