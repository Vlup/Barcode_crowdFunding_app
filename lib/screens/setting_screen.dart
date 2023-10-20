import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<ThemeModeProvider>(context);

    return Scaffold(
      backgroundColor: setting.backgroundColor,
      appBar: AppBar(
        title: const Text('Setting'),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(129, 199, 132, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Display Setting",
                style: TextStyle(color: setting.textColor),
              ),
            ),
            Divider(color: setting.textColor,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Dark Mode',
                  style: TextStyle(color: setting.textColor),
                ),
                Switch(
                  value: setting.isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      setting.isDarkMode = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}