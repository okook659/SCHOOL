import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/datetime/date_time_helper.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  List<ExpenseItem> overalExpenseList = [];
  List<ExpenseItem> _expenses = [];

  List<ExpenseItem> get expenses => _expenses;

  late double money = 0;

  Future<double?> getMoneyOfUSer() async {
    User? user = FirebaseAuth.instance.currentUser;
    double? money = 0;
    if (user == null) {
      return money;
    } else {
      String uid = user.uid;
      DocumentReference userMoney =
          FirebaseFirestore.instance.collection('users').doc(uid);
      try {
        DocumentSnapshot<Object?> documentSnapshot = await userMoney.get();
        money = documentSnapshot.get('money');
        print("");
        return money! - calculateTotalExpenses();
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getExpenses() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is signed in");
      return;
    }

    String uid = user.uid;

    CollectionReference userExpenses = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');

    try {
      QuerySnapshot querySnapshot = await userExpenses.get();

      _expenses = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return ExpenseItem(
          expenseId: doc.id,
          amount: data['amount'],
          name: data['name'],
          dateTime: DateTime.parse(data['dateTime']),
        );
      }).toList();

      notifyListeners();
      print("");
    } catch (error) {
      print("Failed to fetch expenses: $error");
    }
  }

  List<ExpenseItem> getAllExpenseList() {
    getExpenses();
    overalExpenseList = _expenses;
    return overalExpenseList;
  }

  void addNewExpense(ExpenseItem newExpense) {
    overalExpenseList.add(newExpense);

    getAllExpenseList();
    notifyListeners();
  }

// récupérer l'ensemble des dépenses de l'user
  double calculateTotalExpenses() {
    double total = 0;
    for (var expense in _expenses) {
      total += double.parse(expense.amount);
    }
    return total;
  }

  Future<void> addExpense(String amount, String name, DateTime dateTime) async {
    // Obtenir l'UID de l'utilisateur connecté
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is signed in");
      return;
    }

    String uid = user.uid;

//Récupérer l'argent de l'utilisateur
    double userMoney = await getMoneyOfUSer() ?? 0.0;

    if (userMoney < double.parse(amount)) {
      print("Vous n'avez pas suffisamment d'argent pour faire cette dépense.");

      return;
    } else {
      setMoneyOfUser(double.parse(amount), false);

      // Référence à la collection des dépenses de l'utilisateur
      CollectionReference userExpenses = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('expenses');

      try {
        userExpenses.add({
          'amount': amount,
          'name': name,
          'dateTime': dateTime.toIso8601String(),
          // Utiliser toIso8601String pour un format de date standardisé
        });
        SnackBar(
          content: Text("Dépense ajoutée"),
        );
      } catch (error) {
        SnackBar(
            content: Text('Erreur lors de l\'ajout de la dépense : $error'));
      }
    }
  }

  //set money method
  Future<void> setMoneyOfUser(double money, bool add) async {
    // Obtenir l'UID de l'utilisateur connecté
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is signed in");
      return;
    }

    String uid = user.uid;
    if (add) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'money': FieldValue.increment(money)});
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'money': FieldValue.increment(-money)});
    }
  }

  // delete a new expense
  void deleteExpense(ExpenseItem expense) {
    overalExpenseList.remove(expense);
    deleteAnExpense(expense.name);
    setMoneyOfUser(double.tryParse(expense.amount) ?? 0.0, true);
    getAllExpenseList();
    notifyListeners();
  }

  Future<void> deleteAnExpense(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is signed in");
      return;
    }
    String uid = user.uid;

    CollectionReference userExpenses = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('expenses');

    try {
      QuerySnapshot querySnapshot =
          await userExpenses.where('name', isEqualTo: name).get();

      // ExpenseItem expenseItem = ExpenseItem(expenseId: q, name: name, amount: amount, dateTime: dateTime)

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
        overalExpenseList.remove(doc);
      }

      _expenses.removeWhere((expense) => expense.name == name);
      notifyListeners();
      print("Expense Deleted");
    } catch (error) {
      print("Failed to delete expense: $error");
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

//j'avais mis overalExpenses
    for (var expense in _expenses) {
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
