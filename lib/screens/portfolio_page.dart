import 'package:crowdfunding/model/alphavantage.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:crowdfunding/widget/detail_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({Key? key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final AlphavantageApi api = AlphavantageApi();
  Map<String, dynamic> portfolioData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPortfolioData('berkshire');
  }

  void _fetchPortfolioData(String symbol) async {
    final result = await api.fetchStockData(symbol);

    setState(() {
      portfolioData = result;
      isLoading = false;
    });
  }

@override
Widget build(BuildContext context) {
  final setting = Provider.of<ThemeModeProvider>(context);

  return Scaffold(
    backgroundColor: setting.backgroundColor,
    appBar: AppBar(
      title: Text('Portfolio'),
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stock Value     : \$10.000.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: setting.textColor)),
                Text('Asset Value     : \$10.550.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: setting.textColor)),
                Text('Cash Equivalent : \$550.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: setting.textColor)),
                Text('Cash on T+2     : \$205.000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: setting.textColor)),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Symbol', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: setting.textColor)),
                  Text('Average', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: setting.textColor)),
                  Text('Shares', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: setting.textColor)),
                  Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: setting.textColor)),
                ],
              ),
            ),
            SizedBox(height: 8),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: portfolioData['bestMatches'].length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      final match = portfolioData['bestMatches'][index];
                      return ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DetailAlertDialog(symbol: match['1. symbol']);
                            },
                          );
                        },
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text('${match['1. symbol']}', textAlign: TextAlign.center, style: TextStyle(color: setting.textColor, fontSize: 14)),
                            ),
                            Expanded(
                              child: Text('\$500', textAlign: TextAlign.center, style: TextStyle(color: setting.textColor, fontSize: 14)),
                            ),
                            Expanded(
                              child: Text('2000', textAlign: TextAlign.center,style: TextStyle(color: setting.textColor, fontSize: 14)),
                            ),
                            Expanded(
                              child: Text('\$1.000.000', textAlign: TextAlign.center,style: TextStyle(color: setting.textColor, fontSize: 14)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    ),
  );
}
}