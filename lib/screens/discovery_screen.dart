import 'package:crowdfunding/model/alphavantage.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:crowdfunding/widget/detail_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final AlphavantageApi api = AlphavantageApi();
  Map<String, dynamic> data = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStockData('a');
  }

  void _fetchStockData(String keyword) async {
    final result = await api.fetchStockData(keyword);

    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<ThemeModeProvider>(context);

    return Center(
      child: isLoading 
      ? const CircularProgressIndicator()
      : ListView.separated(
        shrinkWrap: true,
        itemCount: data['bestMatches'].length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          final match = data['bestMatches'][index];
          return ListTile(
            onTap: () {
              showDialog(context: context, builder: (context) {
                return DetailAlertDialog(symbol: match['1. symbol']);
              });
            },
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: setting.textColor,
              child: Text((index+1).toString(), style: TextStyle(color: setting.backgroundColor),),
            ),
            title: Text(match['2. name'], style: TextStyle(color: setting.textColor),),
            subtitle: Text('Symbol: ${match['1. symbol']}', style: TextStyle(color: setting.textColor),),
          );
        }
      ),
    );
  }
}