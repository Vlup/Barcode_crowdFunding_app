import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/provider/user_provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Symbol',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: setting.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Average',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: setting.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Shares',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: setting.textColor,
                                      ),
                                    ),
                                    Text(
                                      'Total',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: setting.textColor,
                                      ),
                                    ),
                                  ],
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

              // ListView to display stock data
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
                        final stock =
                            stocksData[index].data() as Map<String, dynamic>;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${stock['symbol']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: setting.textColor,
                                    ),
                                  ),
                                  Text(
                                    'Rp. ${stock['average']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: setting.textColor,
                                    ),
                                  ),
                                  Text(
                                    '${stock['shares']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: setting.textColor,
                                    ),
                                  ),
                                  Text(
                                    'Rp. ${stock['total']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: setting.textColor,
                                    ),
                                  ),
                                ],
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
