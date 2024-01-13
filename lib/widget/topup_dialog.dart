import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class TopUpDialog extends StatefulWidget {
  final String docId;

  TopUpDialog({required this.docId});

  @override
  State<TopUpDialog> createState() => _TopUpDialogState(docId: docId);
}

class _TopUpDialogState extends State<TopUpDialog> {
  final String docId;

  _TopUpDialogState({required this.docId});

  TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var descriptionController = "Top up";
    var typeController = "credit";

    return AlertDialog(
      title:
          const Text("Top Up", style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              FilteringTextInputFormatter.digitsOnly
            ],
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Top Up Nominal'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("Confirm"),
          onPressed: () async {
            await addTopUpData(
              docId,
              amountController.text,
              descriptionController.toString(),
              typeController.toString(),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> addTopUpData(
    String docId,
    String amount,
    String description,
    String type,
  ) async {
    try {
      double topUpAmount = double.parse(amount);
      await FirebaseFirestore.instance.collection('wallet_histories').add({
        'userId': docId,
        'amount': topUpAmount,
        'description': description,
        'timestamp': FieldValue.serverTimestamp(),
        'type': type,
      });

      QuerySnapshot walletSnapshot = await FirebaseFirestore.instance
          .collection('wallets')
          .where('userId', isEqualTo: docId)
          .get();

      if (walletSnapshot.docs.isNotEmpty) {
        DocumentSnapshot walletDocument = walletSnapshot.docs[0];
        double currentAmount = walletSnapshot.docs[0]['amount'] ?? 0.0;
        double newTotalAmount = currentAmount + topUpAmount;
        await walletDocument.reference.update({'amount': newTotalAmount});
      }
      print('Top Up Berhasil');
    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
    }
  }
}
