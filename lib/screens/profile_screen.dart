import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:crowdfunding/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    String? docId = Provider.of<UserProvider>(context).uid;
    final setting = Provider.of<ThemeModeProvider>(context);
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection('users')
          .doc(docId)
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding:
                const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        minRadius: 20,
                        maxRadius: 70,
                        child: Icon(Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 5, left: 50, right: 50),
                        child: Text(
                          data['name'] ?? '',
                          style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500, color: setting.textColor
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 30, left: 50, right: 50),
                        child: Text(
                          data['about_me'] ?? '',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400, color: setting.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color:
                              data['isVerified'] ?? false ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          data['isVerified'] ?? false ? 'Verified' : 'Not Verified',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('wallets').where('userId', isEqualTo: docId).snapshots(), 
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final walletData = snapshot.data!.docs;
                            final wallet = walletData[0].data() as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                'Your Wallet: ${wallet['amount']}',
                                style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500, color: setting.textColor),
                              ),
                            );
                          }
                          return Container();
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Phone Number: ${data['phone_number'] ?? ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500, color: setting.textColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Email Address: ${data['email'] ?? ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500, color: setting.textColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Address: ${data['address'] ?? ''}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500, color: setting.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
