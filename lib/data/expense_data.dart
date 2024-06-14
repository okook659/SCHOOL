import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/datetime/date_time_helper.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overalExpenseList = [];


  // // get expense list
  // List<ExpenseItem> getAllExpenseList() {
  //   return overalExpenseList;
  // }

  Future<void> getAllExpenseList() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('expenses').get();
      overalExpenseList = querySnapshot.docs.map((doc) {
        return ExpenseItem(
          // id: doc.id,  // Vous n'avez pas besoin d'ID ici
          name: doc['name'],
          amount: doc['amount'],
          dateTime: (doc['dateTime'] as Timestamp).toDate(),
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print("Failed to get expenses: $e");
    }
  }


  // add a new expense
  void addNewExpense(ExpenseItem newExpense) {
    overalExpenseList.add(newExpense);

    addExpense(newExpense.amount, newExpense.name, newExpense.dateTime);
    notifyListeners();
  }

//   Future<void> addNewExpense(String userId, String amount, String name, DateTime dateTime) async {
//   CollectionReference expenses = FirebaseFirestore.instance.collection('users').doc(userId).collection('expenses');

//   return expenses.add({
//     'name': name,
//     'amount': amount,
//     'dateTime': dateTime.toString,
//   })
//   .then((value) => print("Expense Added"))
//   .catchError((error) => print("Failed to add expense: $error"));
// }

  Future<void> addExpense(String amount, String name, DateTime dateTime) async {
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('expenses');

    return expenses
        .add({
          'amount': amount,
          'name': name,
          'dateTime': dateTime.toString(),
        })
        .then((value) => print("Expense Added"))
        .catchError((error) => print("Failed to add expense: $error"));
  }

  // delete a new expense
  // void deleteExpense(ExpenseItem expense) {
  //   overalExpenseList.remove(expense);
  //   deleteAnExpense(expense);
  //   notifyListeners();
  // }

  Future<void> deleteAnExpense(String name) async {
    CollectionReference expenses =
        FirebaseFirestore.instance.collection('expenses');

    QuerySnapshot querySnapshot =
        await expenses.where('name', isEqualTo: name).get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    for (var expense in overalExpenseList) {
      if (expense.name == name) {
        overalExpenseList.remove(expense);
        notifyListeners();
        break;
      }
    }

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
