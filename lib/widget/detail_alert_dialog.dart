import 'package:crowdfunding/model/alphavantage.dart';
import 'package:flutter/material.dart';

class DetailAlertDialog extends StatefulWidget {
  final String symbol;

  DetailAlertDialog({required this.symbol});

  @override
  _DetailAlertDialogState createState() => _DetailAlertDialogState();
}

class _DetailAlertDialogState extends State<DetailAlertDialog> {
  final AlphavantageApi api = AlphavantageApi();
  Map<String, dynamic> data = {};
  bool isLoading = true;

  void _getDetailStock(String symbol) async {
    final result = await api.getDetailStockData(symbol);
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getDetailStock(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
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