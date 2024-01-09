import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './firebaseServices.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Define options for the transaction type dropdown
  final List<String> transactionTypes = ['Expense', 'Income'];
  String selectedTransactionType = 'Expense';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTransactionType,
              onChanged: (value) {
                setState(() {
                  selectedTransactionType = value!;
                });
              },
              items: transactionTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Transaction Type'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveTransaction();
              },
              child: Text('Submit Transaction',
                  style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveTransaction() async {
    try {
      // Extract data from controllers
      final double amount = double.parse(amountController.text);
      final String transactionType = selectedTransactionType;
      final String category = categoryController.text;
      final String description = descriptionController.text;

      // Use FirebaseAuthService to get the UID of the logged-in user
      final String? uid = FirebaseAuthService().getCurrentUserUid();

      if (uid == null || uid.isEmpty) {
        // Handle the case where the user is not logged in
        print('User not logged in!');
        return;
      }

      // Reference to the 'transactions' collection with user-specific subcollection
      final CollectionReference userTransactions = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('transactions');

      // Generate a unique ID manually
      final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

      // Add a new document with the unique ID
      await userTransactions.doc(uniqueId).set({
        'id': uniqueId,
        'amount': amount,
        'transactionType': transactionType,
        'category': category,
        'description': description,
        'date': DateTime.now(),
      });

      // Success message (you can replace this with your own UI feedback)
      print('Transaction saved successfully!');
    } catch (e) {
      // Handle errors (you can replace this with your own error handling)
      print('Error saving transaction: $e');
    }

    // After saving, navigate back to the home page
    Navigator.pop(context);
  }
}
