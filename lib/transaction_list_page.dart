import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('transactions').snapshots(),
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
                      Text('Date: ${transaction['date']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Implement the edit functionality here
                          // For example, you can navigate to an edit screen
                          // Navigator.pushNamed(context, '/edit_transaction', arguments: transaction);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implement the delete functionality here
                          // For example, you can show a confirmation dialog and delete the transaction if confirmed
                          showDeleteConfirmationDialog(context, transaction);
                        },
                      ),
                    ],
                  ),
                  // Implement onTap to navigate to a detailed view if needed
                  // onTap: () => Navigator.pushNamed(context, '/transaction_details', arguments: transaction),
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
    // Implement the delete logic here
    // For example, you can delete the transaction from Firestore
    FirebaseFirestore.instance
        .collection('transactions')
        .doc(transaction['id'])
        .delete();
  }
}
