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
    Provider.of<ExpenseData>(context, listen: false).addExpense(
      amount,
      newExpenseNameController.text,
      DateTime.now(),
    );

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

// cancel
  void cancel() {
    Navigator.pop(context);
    clear();
  }

// clear controllers
  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
        builder: (context, value, child) => Scaffold(
              // appBar: AppBar(
              //   backgroundColor: Colors.grey[500],
              //   centerTitle: true,
              //   title: Text(
              //     "Logged in as: " + user.email!,
              //     style: const TextStyle(fontSize: 20),
              //   ),
              //   actions: [
              //     IconButton(
              //         onPressed: signUserOut,
              //         color: Colors.white,
              //         hoverColor: Colors.blueAccent,
              //         icon: Icon(Icons.logout))
              //   ],
              // ),
              backgroundColor: Color(0xFFE5DACE),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Color(0xFFCB6330),
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
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Color(0xFFD69369),
                              borderRadius: BorderRadius.circular(20)),
                          height: 200,
                          //width: 400,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Logged in as: " + user.email!,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: signUserOut,
                                icon: Icon(Icons.logout_rounded),
                                color: Colors.white,
                              ),
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.getAllExpenseList().length,
                    itemBuilder: (context, index) => ExpenseTile(
                        name: value.getAllExpenseList()[index].name,
                        amount: value.getAllExpenseList()[index].amount,
                        dateTime: value.getAllExpenseList()[index].dateTime),
                  ),
                ],
              ),
            ));
  }
}
