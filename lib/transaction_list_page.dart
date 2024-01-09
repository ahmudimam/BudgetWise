import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './firebaseServices.dart';

class TransactionListPage extends StatelessWidget {
  final String? uid = FirebaseAuthService().getCurrentUserUid();
  @override
  Widget build(BuildContext context) {
    if (uid == null) {
      // If the user is not logged in, you can handle it accordingly
      return Scaffold(
        appBar: AppBar(
          title: Text('Transaction List'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('transactions')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<DocumentSnapshot> transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction =
                  transactions[index].data() as Map<String, dynamic>;
              // Format the date
              String formattedDate = DateFormat.yMd()
                  .add_jm()
                  .format(transaction['date'].toDate());

              return Card(
                elevation: 3,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Amount: \$${transaction['amount']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Type: ${transaction['transactionType']}'),
                      Text('Category: ${transaction['category']}'),
                      Text('Description: ${transaction['description']}'),
                      Text('Date: $formattedDate'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/edit_transaction',
                            arguments: {
                              'id': transaction['id'],
                              'amount': transaction['amount'],
                              'transactionType': transaction['transactionType'],
                              'category': transaction['category'],
                              'description': transaction['description'],
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implement the delete functionality here
                          showDeleteConfirmationDialog(context, transaction);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void showDeleteConfirmationDialog(
      BuildContext context, Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Transaction'),
          content: Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement the delete logic here
                // For example, you can delete the transaction from Firestore
                // and then close the dialog
                deleteTransaction(transaction);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void deleteTransaction(Map<String, dynamic> transaction) {
    print('Deleting transaction with ID: ${transaction['id']}');
    // Implement the delete logic here
    FirebaseFirestore.instance
        .collection('users') // Make sure you're using the correct collection
        .doc(uid) // Add the user-specific document ID
        .collection('transactions')
        .doc(transaction['id'])
        .delete()
        .then((_) => print('Transaction deleted successfully'))
        .catchError((error) => print('Error deleting transaction: $error'));
  }
}
