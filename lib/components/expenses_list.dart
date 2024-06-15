import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/expense_item.dart';

class ExpensesList extends StatelessWidget {
  ExpensesList({Key? key}) : super(key: key);

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String uid = user!.uid;
    if (user == null) {
      // Gérer le cas où aucun utilisateur n'est connecté
      return Center(
        child: Text('No user is signed in'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('expenses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          List<ExpenseItem> expenses = [];
          snapshot.data!.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            expenses.add(ExpenseItem(
              expenseId: doc.id,
              amount: data['amount'],
              name: data['name'],
              dateTime: DateTime.parse(data['dateTime']),
            ));
          });

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ListTile(
                title: Text(expense.name),
                subtitle: Text(
                    'Amount: ${expense.amount}, Date: ${expense.dateTime}'),
                // Gérer la suppression de la dépense
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {},
                ),
              );
            },
          );
        }
      },
    );
  }
}
