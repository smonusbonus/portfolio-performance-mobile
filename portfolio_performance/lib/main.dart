import 'dart:io';

import 'package:flutter/material.dart';
import 'package:portfolio_performance/securities_list.dart';
import 'package:portfolio_performance/security.dart';
import 'package:xml/xml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Portfolio Performance'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  List<Security?> securities = List.empty();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late XmlDocument portfolioXml;

  @override
  void initState() {
    super.initState();

    // this won't work on web (no file i/o allowed in browser)
    final file = File(
        '/Users/skreiser/Development/portfolio-performance-flutter-mobile-app/portfolio_performance/portfolio.xml');
    portfolioXml = XmlDocument.parse(file.readAsStringSync());
  }

  List<Security?> _getSecurities() {
    var securitiesXml =
        portfolioXml.rootElement.getElement('securities')?.children;
    if (securitiesXml != null) {
      List<Security?> securities = securitiesXml
          .map((sec) {
            var historicPrices = sec
                    .getElement('prices')
                    ?.children
                    .reversed
                    .where((node) => !(node is XmlText)) ??
                [];

            if (sec.getElement('uuid')?.text != null &&
                sec.getElement('name')?.text != null) {
              return Security(
                uuid: sec.getElement('uuid')!.text,
                name: sec.getElement('name')!.text.trim(),
                currency: sec.getElement('currencyCode')?.text,
                isin: sec.getElement('isin')?.text,
                onlineId: sec.getElement('onlineId')?.text,
                latestPrice: historicPrices.isNotEmpty
                    ? int.tryParse(historicPrices.first.getAttribute('v') ?? '')
                    : null,
                previousDayPrice: historicPrices.isNotEmpty
                    ? int.tryParse(
                        historicPrices.elementAt(1).getAttribute('v') ?? '')
                    : null,
              );
            }
            return null;
          })
          .where((element) => element != null)
          .toList();

      securities.sort(
          (a, b) => a!.name.toLowerCase().compareTo(b!.name.toLowerCase()));
      return securities;
    }
    return List.empty();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SecuritiesList(securities: _getSecurities()),
    );
  }
}
