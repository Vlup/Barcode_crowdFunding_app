import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String docId = 'uqtyFrpmKyJzf3BT4MiQ';
  @override
  Widget build(BuildContext context) {
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data['name'] ?? '',
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              child: const Icon(
                                Icons.edit,
                              ),
                              onTap: () {
                                // Tampilkan dialog pengeditan untuk memungkinkan pengguna mengubah data
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    // Gunakan TextEditingController untuk mengambil input pengguna
                                    TextEditingController nameController =
                                        TextEditingController(
                                            text: data['name']);
                                    TextEditingController addressController =
                                        TextEditingController(
                                            text: data['address']);
                                    TextEditingController
                                        identityPathController =
                                        TextEditingController(
                                            text: data['identity_path']);
                                    TextEditingController aboutMeController =
                                        TextEditingController(
                                            text: data['about_me']);

                                    return AlertDialog(
                                      title: const Text("Edit Profile"),
                                      content: Column(
                                        children: <Widget>[
                                          TextField(
                                            controller: nameController,
                                            decoration: const InputDecoration(
                                                labelText: 'Name'),
                                          ),
                                          TextField(
                                            controller: addressController,
                                            decoration: const InputDecoration(
                                                labelText: 'Address'),
                                          ),
                                          TextField(
                                            controller: identityPathController,
                                            decoration: const InputDecoration(
                                                labelText: 'Identity Path'),
                                          ),
                                          TextField(
                                            controller: aboutMeController,
                                            decoration: const InputDecoration(
                                                labelText: 'About Me'),
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
                                          child: const Text("Save"),
                                          onPressed: () {
                                            // Simpan perubahan ke Firebase Firestore
                                            updateProfileData(
                                              docId,
                                              nameController.text,
                                              addressController.text,
                                              identityPathController.text,
                                              aboutMeController.text,
                                            );
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 30, left: 50, right: 50),
                        child: Text(
                          data['about_me'] ?? '',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w400),
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
                              data['is_verified'] ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: Text(
                          data['is_verified'] ? 'Verified' : 'Not Verified',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Phone Number: ${data['phone_number'] ?? ''}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Email Address: ${data['email'] ?? ''}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Address: ${data['address'] ?? ''}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text(
                          'Identity Card:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: data['identity_path'] != null
                            ? Image.asset(data['identity_path'])
                            : Container(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> updateProfileData(
    String docId,
    String newName,
    String newAddress,
    String newIdentityPath,
    String newAboutMe,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'name': newName,
        'address': newAddress,
        'identity_path': newIdentityPath,
        'about_me': newAboutMe,
      });
      print('Data berhasil diupdate');
    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
    }
  }
}
