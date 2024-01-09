import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the transaction entry screen
                Navigator.pushNamed(context, '/add_transaction');
              },
              child: Text('Add Transaction',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the transaction list screen
                Navigator.pushNamed(context, '/transaction_list');
              },
              child: Text('Transaction List',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.orange, // Background color
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the budget overview screen
                Navigator.pushNamed(context, '/budget_overview');
              },
              child: Text('Budget Overview',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.purple, // Background color
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Logout', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.red, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
