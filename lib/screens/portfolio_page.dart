import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/provider/user_provider.dart';
import 'package:crowdfunding/model/alphavantage.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final AlphavantageApi api = AlphavantageApi();
  final TextEditingController _stockController = TextEditingController();
 
  void _sellStock(String stockId, String symbol, String userId) async {
    Map<String, dynamic> data = await api.getDetailStockData(symbol);
    num price = num.parse(data['Global Quote']["05. price"]);
    num shares = num.parse(_stockController.text);
    num totalAmount = price * shares;

    try {
      QuerySnapshot walletSnapshot = await FirebaseFirestore.instance
        .collection('wallets')
        .where('userId', isEqualTo: userId)
        .get();

      if (walletSnapshot.docs.isNotEmpty) {
        DocumentSnapshot walletDocument = walletSnapshot.docs[0];
        num currentAmount = walletSnapshot.docs[0]['amount'] ?? 0.0;
        num newTotalAmount = currentAmount + totalAmount;
        await walletDocument.reference.update({'amount': newTotalAmount});
      }

      DocumentSnapshot stockSnapshot = await FirebaseFirestore.instance
        .collection('stocks')
        .doc(stockId)
        .get();
        
      num currentShares = stockSnapshot['share'] ?? 0;
      num newShares = currentShares - shares;

      if (newShares <= 0) {
        await FirebaseFirestore.instance.collection('stocks').doc(stockId).delete();
      } else {
        await FirebaseFirestore.instance.collection('stocks').doc(stockId).update({
          'share': newShares,
        });
      }

      await FirebaseFirestore.instance.collection('wallet_histories').add({
        'userId': userId,
        'amount': totalAmount ,
        'description': "Selling stock",
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'credit',
      }).then((value) {
        setState(() {
          _stockController.text = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully Sell Stock!'),
            duration: Duration(milliseconds: 2000)
          )
        );
        Navigator.of(context).pop();
      });
    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? docId = Provider.of<UserProvider>(context).uid;
    final setting = Provider.of<ThemeModeProvider>(context);

    return Scaffold(
      backgroundColor: setting.backgroundColor,
      appBar: AppBar(
        title: const Text('Portfolio'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stocks')
                    .where('userId', isEqualTo: docId)
                    .snapshots(),
                builder: (context, stockSnapshot) {
                  if (stockSnapshot.hasData) {
                    final stocksData = stockSnapshot.data!.docs;
                    double totalStockValue = 0.0;

                    for (int i = 0; i < stocksData.length; i++) {
                      final stock = stocksData[i].data() as Map<String, dynamic>;
                      totalStockValue += stock['total'] ?? 0.0;
                    }

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('wallets')
                          .where('userId', isEqualTo: docId)
                          .snapshots(),
                      builder: (context, walletSnapshot) {
                        if (walletSnapshot.hasData) {
                          final walletsData = walletSnapshot.data!.docs;

                          double totalCashEquivalent = 0.0;
                          double totalAssetValue = 0.0;

                          for (int i = 0; i < walletsData.length; i++) {
                            final wallet =
                                walletsData[i].data() as Map<String, dynamic>;
                            totalAssetValue = totalAssetValue + wallet['amount'] + totalStockValue;
                            totalCashEquivalent += wallet['amount'] ?? 0.0;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Stock Value     : Rp. ${totalStockValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: setting.textColor,
                                ),
                              ),
                              Text(
                                'Asset Value     : Rp. ${totalAssetValue.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: setting.textColor,
                                ),
                              ),
                              Text(
                                'Cash Equivalent : Rp. ${totalCashEquivalent.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: setting.textColor,
                                ),
                              ),
                              Text(
                                'Cash on T+2     : Rp. ${totalCashEquivalent.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: setting.textColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 3),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text(
                                          'Sell',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: setting.textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Symbol',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: setting.textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: Text(
                                          'Average',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: setting.textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        child: Text(
                                          'Shares',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: setting.textColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 80,
                                        child: Text(
                                          'Total',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: setting.textColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                color: setting.textColor,
                                thickness: 2.0,
                                height: 20.0,
                              ),
                              const SizedBox(height: 8),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stocks')
                    .where('userId', isEqualTo: docId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stocksData = snapshot.data!.docs;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: stocksData.length,
                      itemBuilder: (context, index) {
                        final stock = stocksData[index].data() as Map<String, dynamic>;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context, 
                                              builder: (ctx) => AlertDialog(
                                                title: const Text('Sell Stock'),
                                                content: TextField(
                                                  controller: _stockController,
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    hintText: 'Stock Amount',
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
                                                      if (int.parse(_stockController.text) > stock['share']) {
                                                        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(
                                                            content: const Text('The amount must be below than the share you own!'),
                                                            backgroundColor: Colors.red,
                                                            action: SnackBarAction(
                                                              label: 'OK',
                                                              textColor: Colors.white,
                                                              onPressed: () {
                                                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                        setState(() {
                                                          _stockController.text = '';
                                                        });
                                                        Navigator.of(context).pop();
                                                      } else if (_stockController.text.isNotEmpty) {
                                                        _sellStock(
                                                          stocksData[index].id, 
                                                          stock['symbol'],
                                                          docId!
                                                        ); 
                                                      }
                                                    },
                                                    child: const Text('Sell', style: TextStyle(color: Colors.white),)
                                                  ),
                                                ],
                                              )
                                            );
                                          },
                                          child: const Text('Sell'),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        '${stock['symbol']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: setting.textColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        'Rp. ${stock['price']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: setting.textColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        '${stock['share']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: setting.textColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        '${stock['total']}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: setting.textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: setting.textColor,
                              thickness: 1.0,
                              height: 10.0,
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
