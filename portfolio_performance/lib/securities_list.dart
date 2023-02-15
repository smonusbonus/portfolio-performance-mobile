import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:portfolio_performance/pr_security.dart';

class SecuritiesList extends StatefulWidget {
  const SecuritiesList({super.key, required this.securities});

  final List<PRSecurity?> securities;

  @override
  State<SecuritiesList> createState() => _SecuritiesListState();
}

class _SecuritiesListState extends State<SecuritiesList> {
  @override
  void initState() {
    super.initState();
  }

  Future<PRSecurity> _fetchSecurity(PRSecurity prSecurity) async {
    if (prSecurity.onlineId != null) {
      var response = await http.get(Uri.parse(
          'https://api.portfolio-report.net/securities/uuid/${prSecurity.onlineId}'));

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        return PRSecurity.fromJson(jsonDecode(response.body));
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load security');
      }
    }
    return prSecurity;
  }

  Future<List<PRSecurity?>> _fetchSecurities(List<PRSecurity?> prSecurities) {
    // var securities = prSecurities.map((prSec) => _fetchSecurity(prSec));
    return Future.value(prSecurities);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchSecurities(widget.securities),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasData) {
                return SizedBox(
                    height: 600.0,
                    child: ListView(
                        children: snapshot.data!
                            .toList()
                            .map((e) => Container(
                                height: 50,
                                child: Center(
                                  child: Text('${e?.name} - ${e?.isin}'),
                                )))
                            .toList()));
              }
              return Text('Failed to load data');
          }
        });
  }
}
