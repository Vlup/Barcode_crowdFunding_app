import 'package:flutter/material.dart';
import 'package:indexed/indexed.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      child: Column(
        children:  [
          Center(child: Column(children: const [
            CircleAvatar(
              minRadius: 20,
              maxRadius: 70,
              child: Icon(Icons.person),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 5, left: 50, right: 50),
              child: Text('Angeline Ho', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, bottom: 30, left: 50, right: 50),
              child: Text('Interested in Trading', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),),
            ),
          ],),),
          Divider(),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Phone Number: 08593743273', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Email Address: dummy@gmail.com', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Address: Jl. Thamrin', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Country: Indonesia', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text('Identity Card:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Image.asset('images/identity_card_example.jpeg'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}