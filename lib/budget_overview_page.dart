import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Overview'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FutureBuilder<Map<String, double>>(
          future: fetchChartData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            Map<String, double> chartData = snapshot.data ?? {};
            double totalIncome = chartData['Income'] ?? 0.0;
            double totalExpenses = chartData['Expenses'] ?? 0.0;

            return Container(
              //mainAxisAlignment: MainAxisAlignment.center,
              child: PieChart(
                PieChartData(
                  sections: generateSections(chartData),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  centerSpaceColor: Color.fromARGB(255, 200, 192, 192),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, double>> fetchChartData() async {
    QuerySnapshot<Map<String, dynamic>> transactions =
        await FirebaseFirestore.instance.collection('transactions').get();

    double totalIncome = 0.0;
    double totalExpenses = 0.0;

    transactions.docs.forEach((doc) {
      double amount = doc['amount'];
      String transactionType = doc['transactionType'];

      if (transactionType == 'Income') {
        totalIncome += amount;
      } else if (transactionType == 'Expense') {
        totalExpenses += amount;
      }
    });

    return {'Income': totalIncome, 'Expenses': totalExpenses};
  }

  List<PieChartSectionData> generateSections(Map<String, double> chartData) {
    List<PieChartSectionData> sections = [];

    chartData.forEach((category, value) {
      sections.add(
        PieChartSectionData(
          color: getCategoryColor(category),
          value: value,
          title: '$category\n\$${value.toStringAsFixed(2)}',
          radius: 60,
          titleStyle: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: const Color(0xff0f4a3c),
          ),
        ),
      );
    });

    return sections;
  }

  Color getCategoryColor(String category) {
    return category == 'Income' ? Colors.green : Colors.red;
  }
}
