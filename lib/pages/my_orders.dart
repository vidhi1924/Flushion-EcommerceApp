import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('My Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          // Sorted client-side to avoid requiring a composite Firestore index
          // for a where + orderBy on different fields.
          final orders = snapshot.data!.docs.toList()
            ..sort((a, b) {
              final aTime = a.data() as Map<String, dynamic>;
              final bTime = b.data() as Map<String, dynamic>;
              final aTs = aTime['createdAt'] as Timestamp?;
              final bTs = bTime['createdAt'] as Timestamp?;
              if (aTs == null || bTs == null) return 0;
              return bTs.compareTo(aTs);
            });
          if (orders.isEmpty) {
            return Center(
              child: Text('No orders yet',
                  style: TextStyle(color: Colors.grey)),
            );
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              final items = (order['items'] as List?) ?? [];
              final total = (order['total'] as num?)?.toDouble() ?? 0;
              final status = order['status'] ?? 'Placed';
              final createdAt = order['createdAt'] as Timestamp?;
              return Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 6.0),
                child: ExpansionTile(
                  title: Text('\$${total.toStringAsFixed(2)} · $status'),
                  subtitle: Text(createdAt != null
                      ? createdAt.toDate().toString()
                      : 'Pending'),
                  children: items.map<Widget>((item) {
                    final map = item as Map<String, dynamic>;
                    return ListTile(
                      leading: map['images'] != null
                          ? Image.network(map['images'],
                              width: 40, height: 40, fit: BoxFit.cover)
                          : null,
                      title: Text('${map['name']}'),
                      trailing: Text('x${map['quantity']}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
