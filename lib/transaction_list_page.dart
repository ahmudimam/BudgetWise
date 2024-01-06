import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction List'),
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

              return ListTile(
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
                // Implement onTap to navigate to a detailed view if needed
                // onTap: () => Navigator.pushNamed(context, '/transaction_details', arguments: transaction),
              );
            },
          );
        },
      ),
    );
  }
}
