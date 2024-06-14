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
  // final user = FirebaseAuth.instance.currentUser!;

// text controllers
  final newExpenseNameController = TextEditingController();
  final newExpenseDollarController = TextEditingController();
  final newExpenseCentsController = TextEditingController();

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
                      //dollars
                      Expanded(
                        child: TextField(
                          controller: newExpenseDollarController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Dollars",
                          ),
                        ),
                      ),

                      //cents
                      Expanded(
                        child: TextField(
                          controller: newExpenseCentsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: "Cents",
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
  void save() {
// put dollar and cents together
    String amount =
        newExpenseDollarController.text + '.' + newExpenseCentsController.text;

    // create this expense item
    ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameController.text,
        amount: amount,
        dateTime: DateTime.now());

    //add the new expense
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
    newExpenseCentsController.clear();
    newExpenseDollarController.clear();
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
        //   actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
        // ),
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: addNewExpense,
          child: Icon(Icons.add),
        ),
        body:

            // décommenter à la fin
            // Center(
            //   child: Text(
            //     "Logged in as: " + user.email!,
            //     style: const TextStyle(fontSize: 20),
            //   ),
            // ),

            ListView(
          children: [
// weekly summary
            ExpenseSummary(startOfWeek: value.startOfWeekDate()),

            const SizedBox(
              height: 20,
            ),

//expense list
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: value.getAllExpenseList().length,
                itemBuilder: (context, index) => ExpenseTile(
                    name: value.getAllExpenseList()[index].name,
                    amount: value.getAllExpenseList()[index].amount,
                    dateTime: value.getAllExpenseList()[index].dateTime)),
          ],
        ),
      ),
    );
  }
}
