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
        padding: const EdgeInsets.all(16),
        scrollDirection: Axis.vertical,
        itemCount: widget.securities.length,
        itemBuilder: (context, index) {
          return buildListItem(index);
        });
  }

  String _currencyCodeToSymbol(String? currency) {
    switch (currency) {
      case "EUR":
        return "€";
      case "USD":
        return '\$';
      default:
        return currency ?? '';
    }
  }

  String _getPrice(Security? sec) {
    double? price;
    if (sec != null && sec.latestPrice != null) {
      price = sec.latestPrice! / 100000000;
      if (sec.currency != null) {
        return '${price.toStringAsFixed(2)} ${_currencyCodeToSymbol(sec.currency)}';
      }
      return price.toString();
    }
    return '';
  }

  num _getPriceChange(Security? sec) {
    if (sec != null &&
        sec.latestPrice != null &&
        sec.previousDayPrice != null) {
      var diff = sec.latestPrice! - sec.previousDayPrice!;
      var isNegative = diff < 0;
      print(diff);
      var result = (diff.abs() / sec.latestPrice!) * 100;

      print(result);
      return isNegative ? result * -1 : result;
    }
    return 0;
  }

  Widget buildListItem(int index) {
    var priceChange = _getPriceChange(widget.securities[index]);

    return Container(
        width: double.infinity,
        height: 50,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Row(
                  children: [
                    Text('${widget.securities[index]?.name}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400))
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_getPrice(widget.securities[index]),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(
                    '${priceChange.toStringAsFixed(2)} %',
                    style: TextStyle(
                        color: priceChange >= 0 ? Colors.green : Colors.red),
                  ),
                ],
              )
            ],
          ),
        ]));
  }
}
