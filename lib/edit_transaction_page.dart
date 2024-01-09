import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './firebaseServices.dart';

class EditTransactionPage extends StatefulWidget {
  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String selectedTransactionType = 'Expense';
  String buttonText = 'Update Transaction';
  late Map<String, dynamic> transactionData;
  final List<String> transactionTypes = ['Expense', 'Income'];

  @override
  void initState() {
    super.initState();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      // Get the transaction data passed from the arguments
      transactionData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      // Set initial values based on the transaction data
      amountController.text = transactionData['amount']?.toString() ?? '';
      selectedTransactionType = transactionData['transactionType'] ?? '';
      categoryController.text = transactionData['category'] ?? '';
      descriptionController.text = transactionData['description'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaction'),
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
                // Handle update logic
                updateTransaction(transactionData['id']);
              },
              child: Text(buttonText, style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Background color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateTransaction(String transactionId) async {
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

      // Update the existing document with the same ID
      await userTransactions.doc(transactionId).update({
        'amount': amount,
        'transactionType': transactionType,
        'category': category,
        'description': description,
        'date': DateTime.now(),
      });

      // Success message (you can replace this with your own UI feedback)
      print('Transaction updated successfully!');
    } catch (e) {
      // Handle errors (you can replace this with your own error handling)
      print('Error updating transaction: $e');
    }

    // After updating, navigate back to the home page
    Navigator.pop(context);
  }
}
