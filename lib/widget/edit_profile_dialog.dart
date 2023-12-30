import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditProfileDialog extends StatefulWidget {
  final String docId;

  EditProfileDialog({required this.docId});

  @override
  _EditProfileDialogState createState() => _EditProfileDialogState(docId: docId);
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final String docId;

  _EditProfileDialogState({required this.docId});

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutMeController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Edit Profile"),
      content: Column(
        children: <Widget>[
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: aboutMeController,
            decoration: const InputDecoration(labelText: 'About Me'),
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
            updateProfileData(
              docId,
              nameController.text,
              phoneNumberController.text,
              aboutMeController.text
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Future<void> updateProfileData(
    String docId,
    String newName,
    String newPhoneNumber,
    String newAboutMe,
  ) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
      'name': newName,
      'phone_number': newPhoneNumber,
      'about_me': newAboutMe,
      });
      print('Data berhasil diupdate');
    } catch (e) {
      print('Terjadi kesalahan saat mengupdate data: $e');
    }
  }
}