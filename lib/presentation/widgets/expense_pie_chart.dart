import 'package:expensetracker/core/utils/color_hex_formatter.dart';
import 'package:expensetracker/domain/entities/transaction.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ExpensePieChart extends StatefulWidget {
  final List<Transaction> transactions;

  ExpensePieChart(this.transactions);

  @override
  _ExpensePieChartState createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int touchedIndex = -1;
  Map<String, Map<String, dynamic>> indicators;
  List<String> colorHexCodes;
  int totalAmount;

  @override
  Widget build(BuildContext context) {
    indicators = {};
    colorHexCodes = [];
    totalAmount = 0;
    widget.transactions.forEach((transaction) {
      var colorhex = transaction.colorHex;
      var amountForThisCategory = 0;
      if (indicators.containsKey(colorhex))
        amountForThisCategory = indicators[colorhex]['amount'];
      else
        colorHexCodes.add(colorhex);
      indicators[colorhex] = {
        'category': transaction.category,
        'amount': amountForThisCategory + transaction.amount,
      };
      totalAmount += transaction.amount;
    });
    print(indicators.length);

    return Row(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                setState(() {
                  final desiredTouch =
                      pieTouchResponse.touchInput is! PointerExitEvent &&
                          pieTouchResponse.touchInput is! PointerUpEvent;
                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                    touchedIndex = pieTouchResponse.touchedSectionIndex;
                  } else {
                    touchedIndex = -1;
                  }
                });
              }),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 1,
              centerSpaceRadius: 60,
              sections: showingSections(),
            ),
          ),
        ),
        Container(
          width: 100,
          child: ListView.builder(
            reverse: true,
            itemCount: indicators.length,
            itemBuilder: (ctx, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor:
                            colorFromHex(indicators.keys.elementAt(index)),
                        radius: 6,
                      ),
                      title: Text(
                        indicators.values.elementAt(index)['category'],
                        style: TextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                      contentPadding: EdgeInsets.all(0),
                      horizontalTitleGap: 0,
                      minLeadingWidth: 15,
                      minVerticalPadding: 0,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      colorHexCodes.length,
      (i) {
        final isTouched = i == touchedIndex;
        final fontSize = isTouched ? 25.0 : 16.0;
        final radius = isTouched ? 60.0 : 40.0;
        final percent =
            (indicators[colorHexCodes[i]]['amount'] * 100) / totalAmount;
        return PieChartSectionData(
          color: colorFromHex(colorHexCodes[i]),
          value: indicators[colorHexCodes[i]]['amount'].toDouble(),
          title: percent.toInt().toString(),
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        );
      },
    );
  }
}
