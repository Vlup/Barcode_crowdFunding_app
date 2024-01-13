import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/model/alphavantage.dart';
import 'package:crowdfunding/model/stock_model.dart';
import 'package:crowdfunding/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailAlertDialog extends StatefulWidget {
  final String symbol;

  DetailAlertDialog({required this.symbol});

  @override
  _DetailAlertDialogState createState() => _DetailAlertDialogState();
}

class _DetailAlertDialogState extends State<DetailAlertDialog> {
  final AlphavantageApi api = AlphavantageApi();
  final TextEditingController _stockController = TextEditingController();
  Map<String, dynamic> data = {};
  bool isLoading = true;
  bool _validate = false;

  void _getDetailStock(String symbol) async {
    final result = await api.getDetailStockData(symbol);
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  void _buyStock(userId, symbol, double price, double share, double total) async {
    final dbStocks = FirebaseFirestore.instance.collection('stocks');
    try {
      QuerySnapshot walletSnapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .get();

      if (walletSnapshot.docs.isNotEmpty &&
          (walletSnapshot.docs[0]['amount'] ?? 0) >= total
      ) {
        DocumentSnapshot walletDocument = walletSnapshot.docs[0];
        num currentAmount = walletSnapshot.docs[0]['amount'] ?? 0.0;
        num newTotalAmount = currentAmount - total;
        await walletDocument.reference.update({'amount': newTotalAmount});

        final stock = StockModel(
          symbol: symbol,
          price: price, 
          share: share,
          total: total,
          userId: userId
        );

        await FirebaseFirestore.instance.collection('wallet_histories').add({
          'userId': userId,
          'amount': total,
          'description': "Buying stock",
          'timestamp': FieldValue.serverTimestamp(),
          'type': 'debit',
        });

        await dbStocks.add(stock.toJson()).then((value) {
          _stockController.text = '';
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully Purchase Stock!'),
              duration: Duration(milliseconds: 2000)
            )
          );
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to purchase stock! Insufficient Wallet'),
            duration: Duration(milliseconds: 2000)
          )
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      

    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getDetailStock(widget.symbol);
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userId = Provider.of<UserProvider>(context).uid;
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        const Text('Stock Details'),
        if (!isLoading) ... [
          CircleAvatar(
            radius: 15,
            backgroundColor: double.parse(data['Global Quote']['09. change']) >= 0 ?Colors.green : Colors.red,
            child: double.parse(data['Global Quote']['09. change']) >= 0
              ? const Icon(Icons.arrow_upward, color: Colors.white)
              : const Icon(Icons.arrow_downward, color: Colors.white)
          )
        ],
      ],),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close', style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor:  Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
          ),
          onPressed: () {
            showDialog(
              context: context, 
              builder: (ctx) => AlertDialog(
                title: const Text('Buy Stock'),
                content: TextField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Stock Amount',
                    errorText: _validate ? "Value can't be empty" : null,
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('Close', style: TextStyle(color: Colors.blue)),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor:  Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                    onPressed: () { 
                      if (_stockController.text.isNotEmpty) {
                        _buyStock(
                          userId, 
                          data['Global Quote']["01. symbol"],
                          double.parse(data['Global Quote']["05. price"]), 
                          double.parse(_stockController.text), 
                          double.parse(data['Global Quote']["05. price"]) *
                          double.parse(_stockController.text)
                        );
                      } else { 
                        setState(() {
                          _validate = _stockController.text.isEmpty;
                        });
                      }
                    },
                    child: const Text('Buy', style: TextStyle(color: Colors.white),)
                  ),
                ],
              )
            );
          },
          child: const Text('Buy', style: TextStyle(color: Colors.white),)
        ),
      ],
      content: SingleChildScrollView(
        child: isLoading
        ? const CircularProgressIndicator()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Symbol: ${data['Global Quote']["01. symbol"]}'),
              Text('Open: ${data['Global Quote']["02. open"]}'),
              Text('High: ${data['Global Quote']["03. high"]}'),
              Text('Low: ${data['Global Quote']["04. low"]}'),
              Text('Price: ${data['Global Quote']["05. price"]}'),
              Text('Volume: ${data['Global Quote']["06. volume"]}'),
              Text('Latest Trading Day: ${data['Global Quote']["07. latest trading day"]}'),
              Text('Previous Close: ${data['Global Quote']["08. previous close"]}'),
              Text('Change Percent: ${data['Global Quote']["10. change percent"]}'),
            ],
          )
      )
    );
  }
}