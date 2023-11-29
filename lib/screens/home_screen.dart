import 'dart:async';
import 'dart:math';
import 'package:crowdfunding/screens/portfolio_page.dart';
import 'package:crowdfunding/screens/wallet_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:crowdfunding/provider/setting_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  List<DataPoint> dataPoints1 = [];
  List<DataPoint> dataPoints2 = [];
  List<DataPoint> dataPoints3 = [];
  List<DataPoint> dataPoints4 = [];
  List<DataPoint> dataPoints5 = [];

  @override
  void initState() {
    super.initState();
    dataPoints1 = generateDataPoints();
    dataPoints2 = generateDataPoints();
    dataPoints3 = generateDataPoints();
    dataPoints4 = generateDataPoints();
    dataPoints5 = generateDataPoints();
    startTimer();
  }

  List<DataPoint> generateDataPoints() {
    Random random = Random();
    List<DataPoint> points = [];

    for (int i = 1; i <= 20; i++) {
      DateTime date = DateTime(2023, 10, i);
      int value = random.nextInt(4001) + 1000;
      points.add(DataPoint(date, value.toDouble()));
    }

    return points;
  }

  int currentIndex = 0;
  List<String> banners = [
    'images/CFB1.jpg',
    'images/CFB2.jpg',
    'images/CFB3.jpg'
  ];

  void startTimer() {
    const duration = Duration(seconds: 3);
    _timer = Timer.periodic(duration, (Timer timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % banners.length;
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setting = Provider.of<ThemeModeProvider>(context);
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.fill,
              child: Image.asset(
                banners[currentIndex],
                width: 500,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 140,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Color of the shadow
                            blurRadius: 4, // Spread of the shadow
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                        color: const Color.fromRGBO(129, 199, 132, 1),
                        border: Border.all(
                          width: 0.7,
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletPage()));
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.wallet,
                                color: setting.textColor,
                              )),
                           Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Top Up",
                                    style: TextStyle(color: setting.textColor),
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                      )),
                  Container(
                      width: 140,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Color of the shadow
                            blurRadius: 4, // Spread of the shadow
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                        color: const Color.fromRGBO(129, 199, 132, 1),
                        border: Border.all(
                          width: 0.7,
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PortfolioPage()));
                        },
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.assignment,
                                  color: setting.textColor,
                                )),
                            Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "My Portfolio",
                                  style: TextStyle(color: setting.textColor),
                                  textAlign: TextAlign.center,
                                ))
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                      width: 140,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Color of the shadow
                            blurRadius: 4, // Spread of the shadow
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                        color: const Color.fromRGBO(129, 199, 132, 1),
                        border: Border.all(
                          width: 0.7,
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () => {},
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.shopping_cart,
                                  color: setting.textColor,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Quick Buy",
                                    style: TextStyle(color: setting.textColor),
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                      )),
                  Container(
                      width: 140,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey, // Color of the shadow
                            blurRadius: 4, // Spread of the shadow
                            offset: Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                        color: const Color.fromRGBO(129, 199, 132, 1),
                        border: Border.all(
                          color: setting.textColor,
                          width: 0.7,
                        ),
                      ),
                      child: OutlinedButton(
                        onPressed: () => null,
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.sell,
                                  color: setting.textColor,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Quick Sell",
                                    style: TextStyle(color: setting.textColor),
                                    textAlign: TextAlign.center,
                                  )),
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Recomended Stock",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23,  color: setting.textColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CarouselSlider(
                items: [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 199, 132, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const Text(
                          "AAPL",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 175,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              maxY: 5200,
                              // minY: 0,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              minX: 0,
                              maxX: dataPoints1.length.toDouble() - 1,
                              minY: dataPoints1
                                  .map((data) => data.price)
                                  .reduce((a, b) => a < b ? a : b),
                              // maxY: stockData
                              //     .map((data) => data.price)
                              //     .reduce((a, b) => a > b ? a : b),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints1
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.price))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 199, 132, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const Text(
                          "NFLX",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 175,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              maxY: 5200,
                              // minY: 0,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              minX: 0,
                              maxX: dataPoints1.length.toDouble() - 1,
                              minY: dataPoints1
                                  .map((data) => data.price)
                                  .reduce((a, b) => a < b ? a : b),
                              // maxY: stockData
                              //     .map((data) => data.price)
                              //     .reduce((a, b) => a > b ? a : b),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints1
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.price))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 199, 132, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const Text(
                          "TSLA",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 175,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              maxY: 5200,
                              // minY: 0,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              minX: 0,
                              maxX: dataPoints1.length.toDouble() - 1,
                              minY: dataPoints1
                                  .map((data) => data.price)
                                  .reduce((a, b) => a < b ? a : b),
                              // maxY: stockData
                              //     .map((data) => data.price)
                              //     .reduce((a, b) => a > b ? a : b),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints1
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.price))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 199, 132, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const Text(
                          "AMZN",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 175,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              maxY: 5200,
                              // minY: 0,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              minX: 0,
                              maxX: dataPoints1.length.toDouble() - 1,
                              minY: dataPoints1
                                  .map((data) => data.price)
                                  .reduce((a, b) => a < b ? a : b),
                              // maxY: stockData
                              //     .map((data) => data.price)
                              //     .reduce((a, b) => a > b ? a : b),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints1
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.price))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(129, 199, 132, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        child: const Text(
                          "MSFT",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          height: 175,
                          child: LineChart(
                            LineChartData(
                              backgroundColor: Colors.white,
                              maxY: 5200,
                              // minY: 0,
                              gridData: const FlGridData(show: false),
                              titlesData: const FlTitlesData(show: false),
                              borderData: FlBorderData(
                                show: true,
                              ),
                              minX: 0,
                              maxX: dataPoints1.length.toDouble() - 1,
                              minY: dataPoints1
                                  .map((data) => data.price)
                                  .reduce((a, b) => a < b ? a : b),
                              // maxY: stockData
                              //     .map((data) => data.price)
                              //     .reduce((a, b) => a > b ? a : b),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: dataPoints1
                                      .asMap()
                                      .entries
                                      .map((entry) => FlSpot(
                                          entry.key.toDouble(),
                                          entry.value.price))
                                      .toList(),
                                  isCurved: true,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                options: CarouselOptions(
                  height: 400.0, // Customize the height of the carousel
                  enlargeCenterPage: true, // Makes the center item larger
                  autoPlay: true, // Enables auto-play
                  autoPlayInterval:
                    const Duration(seconds: 3), // Set auto-play interval
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DataPoint {
  final DateTime date;
  final double price;

  DataPoint(this.date, this.price);
}
