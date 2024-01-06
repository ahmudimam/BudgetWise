import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Logout'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the transaction entry screen
                Navigator.pushNamed(context, '/add_transaction');
              },
              child: Text('Add Transaction'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the budget overview screen
                Navigator.pushNamed(context, '/budget_overview');
              },
              child: Text('Budget Overview'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the transaction list screen
                Navigator.pushNamed(context, '/transaction_list');
              },
              child: Text('Transaction List'),
            ),
          ],
        ),
      ),
    );
  }
}
