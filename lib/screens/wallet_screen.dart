import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:crowdfunding/provider/user_provider.dart';
import 'package:crowdfunding/widget/topup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {

  @override
  Widget build(BuildContext context) {
    String? docId = Provider.of<UserProvider>(context).uid;
    final setting = Provider.of<ThemeModeProvider>(context);

    String _formatTimestamp(Timestamp timestamp) {
      DateTime dateTime = timestamp.toDate();
      final formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
      return formattedDate;
    }

    return Scaffold(
      backgroundColor: setting.backgroundColor,
      appBar: AppBar(
        title: const Text('Your Wallet'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('wallets')
                        .where('userId', isEqualTo: docId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final walletData = snapshot.data!.docs;
                        final wallet =
                            walletData[0].data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: double.infinity,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade500,
                                        Colors.green.shade700
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.shade700,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'IDR ${wallet['amount']}',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.white
                                              ],
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: Icon(Icons.arrow_upward,
                                                color: Colors.green.shade700),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return TopUpDialog(
                                                      docId: docId!);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('wallet_histories')
                                    .where('userId', isEqualTo: docId)
                                    .snapshots(),
                                builder: (context, historySnapshot) {
                                  if (historySnapshot.hasData) {
                                    final historyData =
                                        historySnapshot.data!.docs;
                                    return Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: setting.isDarkMode
                                                ? [
                                                    Colors.white,
                                                    Colors.grey.shade300
                                                  ]
                                                : [
                                                    Colors.black,
                                                    Colors.grey.shade700
                                                  ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0),
                                                      child: Icon(
                                                          Icons.history_edu,
                                                          color: setting
                                                              .backgroundColor),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      'History',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: setting
                                                              .backgroundColor),
                                                    ),
                                                  ]),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: historyData.length,
                                                itemBuilder: ((context, index) {
                                                  final history =
                                                      historyData[index].data()
                                                          as Map<String,
                                                              dynamic>;
                                                  return ListTile(
                                                      leading: Icon(
                                                        history['type'] ==
                                                                'debit'
                                                            ? Icons
                                                                .stacked_line_chart
                                                            : Icons
                                                                .monetization_on_outlined,
                                                        color:
                                                            history['type'] ==
                                                                    'debit'
                                                                ? Colors.red
                                                                : Colors.green,
                                                      ),
                                                      title: Text(
                                                        history['description'],
                                                        style: TextStyle(
                                                            color: setting
                                                                .backgroundColor),
                                                      ),
                                                      subtitle: Text(
                                                          history['timestamp'] != null ?
                                                        _formatTimestamp(history['timestamp']) : '',
                                                        style: TextStyle(
                                                            color: setting
                                                                .backgroundColor),
                                                      ),
                                                      trailing: Text(
                                                        '${history['type'] == 'credit' ? '+' : '-'} IDR ${history['amount']}',
                                                        style: TextStyle(
                                                          color:
                                                              history['type'] ==
                                                                      'credit'
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                        ),
                                                      ));
                                                }),
                                              ),
                                            ]));
                                  }
                                  return Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: setting.isDarkMode
                                              ? [
                                                  Colors.white,
                                                  Colors.grey.shade300
                                                ]
                                              : [
                                                  Colors.black,
                                                  Colors.grey.shade700
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Icon(Icons.history_edu,
                                                  color:
                                                      setting.backgroundColor),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'History',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      setting.backgroundColor),
                                            ),
                                          ]));
                                }),
                          ],
                        );
                      }
                      return Container();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
