import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:crowdfunding/provider/user_provider.dart';
import 'package:flutter/material.dart';
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

  return Scaffold(
    backgroundColor: setting.backgroundColor,
    appBar: AppBar(
      title: const Text('Your Wallet'),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('wallets').where('userId', isEqualTo: docId).snapshots(), 
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final walletData = snapshot.data!.docs;
                  final wallet = walletData[0].data() as Map<String, dynamic>;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: 150,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade500, Colors.green.shade700],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.shade700,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'IDR ${wallet['amount']}',
                                style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: setting.isDarkMode ? [Colors.white, Colors.grey.shade300] : [Colors.black, Colors.grey.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
                                child: Icon(Icons.arrow_upward, color: setting.backgroundColor),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Top-up',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: setting.backgroundColor),
                              ),
                            ],
                          ),
                        )
                      ),
                    ],
                  );
                }
                return Container();
              }
            ),
          ],
        ),
      ),
    ),
  );
}
}