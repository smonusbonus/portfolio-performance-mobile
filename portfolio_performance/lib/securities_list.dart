import 'package:flutter/material.dart';
import 'package:portfolio_performance/security.dart';

class SecuritiesList extends StatefulWidget {
  const SecuritiesList({super.key, required this.securities});

  final List<Security?> securities;

  @override
  State<SecuritiesList> createState() => _SecuritiesListState();
}

class _SecuritiesListState extends State<SecuritiesList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.securities.length);
    return ListView.builder(
        padding: EdgeInsets.all(12),
        scrollDirection: Axis.vertical,
        itemCount: widget.securities.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        });
  }

  String _getPrice(Security? sec) {
    double? price;
    if (sec != null && sec.latestPrice != null) {
      price = sec.latestPrice! / 100000000;
      if (sec.currency != null) {
        return '${price.toStringAsFixed(2)} ${sec.currency}';
      }
      return price.toString();
    }
    return '';
  }

  Widget buildListItem(int index) {
    return Container(
      width: double.infinity,
      height: 30,
      child: Text(
          '${widget.securities[index]?.name} - ${_getPrice(widget.securities[index])}'),
    );
  }
}
