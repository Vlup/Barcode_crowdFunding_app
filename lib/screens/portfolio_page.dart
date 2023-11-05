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
    _fetchPortfolioData('AAPL'); // You can change the symbol to match your portfolio data.
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
      appBar: AppBar(
        title: Text('Portfolio'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Stock Value: \$XXXX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Asset Value: \$XXXX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Cash Equivalent: \$XXXX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Cash on T+2: \$XXXX', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Symbol', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Average', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Shares', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ],
            ),
          ),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  shrinkWrap: true,
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
                          Text('${match['2. name']}', style: TextStyle(color: setting.textColor, fontSize: 14)),
                          Text('${match['1. symbol']}', style: TextStyle(color: setting.textColor, fontSize: 14)),
                          Text('Average: \$XX.XX', style: TextStyle(color: setting.textColor, fontSize: 14)),
                          Text('Shares: XX', style: TextStyle(color: setting.textColor, fontSize: 14)),
                          Text('Total: \$XX.XX', style: TextStyle(color: setting.textColor, fontSize: 14)),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
