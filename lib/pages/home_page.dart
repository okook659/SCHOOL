import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/components/expense_chart.dart';
import 'package:expenses_tracker/components/expense_summary.dart';
import 'package:expenses_tracker/components/expense_tile.dart';
import 'package:expenses_tracker/models/expense_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/expense_data.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

// text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  final moneyAddController = TextEditingController();
  final moneySubController = TextEditingController();

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add new expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //expense name
                  TextField(
                    controller: newExpenseNameController,
                    decoration: const InputDecoration(
                      hintText: "Expense name",
                    ),
                  ),

                  // expense amount
                  Row(
                    children: [
                      //francs
                      Expanded(
                        child: TextField(
                          controller: newExpenseAmountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Francs CFA",
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: save,
                  child: Text('Save'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                )
              ],
            ));
  }

// save
  void save() async {
// put dollar and cents together
    String amount = newExpenseAmountController.text;

    //create this expense item
    String userId = user.uid;
    ExpenseItem newExpense = ExpenseItem(
        expenseId: userId,
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now());

    //add the new expense
    if (context != null) {
      Provider.of<ExpenseData>(context, listen: false).addExpense(
        amount,
        newExpenseNameController.text,
        DateTime.now(),
      );
    }

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

  double displayMoney() {
    if (context != null) {
      double Total = Provider.of<ExpenseData>(context, listen: false)
              .getMoneyOfUSer()
          as double; // use null-coalescing operator to default to 0.0 if null
      return Total;
    } else {
      return 0.0;
    }
  }

  void add() async {
    double money = double.parse(moneyAddController.text);
    if (context != null) {
      Provider.of<ExpenseData>(context, listen: false)
          .setMoneyOfUser(money, true);
      Navigator.pop(context);
      clear();
    }
  }

  void substract() async {
    double money = double.parse(moneySubController.text);
    if (context != null) {
      Provider.of<ExpenseData>(context, listen: false)
          .setMoneyOfUser(money, false);
      Navigator.pop(context);
      clear();
    }
  }

// cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

// amount
  void addMoney() {
    //create this expense item

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add money'),
              content:

                  //francs
                  Expanded(
                child: TextField(
                  controller: moneyAddController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Francs CFA",
                  ),
                ),
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: add,
                  child: Text('Done'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                )
              ],
            ));
  }

  void substractMoney() {
    //create this expense item

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Substract money'),
              content:

                  //francs
                  Expanded(
                child: TextField(
                  controller: moneySubController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Francs CFA",
                  ),
                ),
              ),
              actions: [
                // save button
                MaterialButton(
                  onPressed: substract,
                  child: Text('Done'),
                ),

                //cancel button
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancel'),
                )
              ],
            ));
  }

// clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
    moneyAddController.clear();
    moneySubController.clear();
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
            child: AppBar(
              backgroundColor: Color(0xFF5E60CE),
              centerTitle: true,
              title: Text(
                "Logged in as: " + user.email!,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontFamily: 'Cambria'),
              ),
              actions: [
                IconButton(
                    onPressed: signUserOut,
                    color: Colors.white,
                    icon: Icon(Icons.logout))
              ],
            ),
          ),
        ),
        //backgroundColor: Color(0xFF9E9190),
        backgroundColor: Color(0xFF010101),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF5E60CE),
          foregroundColor: Colors.white,
          onPressed: addNewExpense,
          child: Icon(Icons.add),
        ),
        body:
            //weekly summarry

            ListView(
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFA52CD4), Color(0xFFA06AD2)],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        shape: BoxShape.rectangle,
                        color: Color(0xFF0CCDA3),
                        borderRadius: BorderRadius.circular(20)),
                    height: 100,
                    //width: 400,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FutureBuilder<double?>(
                          future:
                              Provider.of<ExpenseData>(context, listen: false)
                                  .getMoneyOfUSer(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "Your Money:  ${snapshot.data} XOF",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              );
                            } else {
                              return Text("Loading...");
                            }
                          },
                        ),
                        IconButton(
                          onPressed: addMoney,
                          icon: Icon(Icons.swipe_up),
                          color: Colors.white,
                          iconSize: 30,
                        ),
                        IconButton(
                          onPressed: substractMoney,
                          icon: Icon(Icons.swipe_down),
                          color: Colors.white,
                          iconSize: 30,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ExpenseSummary(
              startOfWeek: value.startOfWeekDate(),
            ),
            SizedBox(
              height: 20,
            ),

            // expense list
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ListView.builder(
                  clipBehavior: Clip.antiAlias,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) => ExpenseTile(
                      name: value.getAllExpenseList()[index].name,
                      amount: value.getAllExpenseList()[index].amount,
                      dateTime: value.getAllExpenseList()[index].dateTime),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
