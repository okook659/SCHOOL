import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseChart extends StatefulWidget {
  @override
  _ExpenseChartState createState() => _ExpenseChartState();
}

class _ExpenseChartState extends State<ExpenseChart> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _expensesStream;
  late LineChartData _chartData;

  @override
  void initState() {
    super.initState();
    _expensesStream = _firestore.collection('expenses').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _expensesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur lors de la récupération des données');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Chargement...");
        }

        List<FlSpot> spots = [];
        snapshot.data?.docs.forEach((document) {
          Map<String, double?> expense =
              document.data() as Map<String, double>;
          if (expense['amount'] != null) {
            double? amt = expense['amount'];
            spots
                .add(FlSpot(expense['dateTime']!, expense['amount']!));
          }
        });

        _chartData = LineChartData(
          lineTouchData: LineTouchData(enabled: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
            ),
          ],
        );

        return LineChart(
          _chartData,
        );
      },
    );
  }
}
