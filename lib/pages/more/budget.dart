import 'dart:ui';

import 'package:YWallet/store2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:graphic/graphic.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../chart.dart';
import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../store.dart';

final DateFormat chartDateFormat = DateFormat("MM-dd");

class BudgetPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetState();
}

class _BudgetState extends State<BudgetPage> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final t = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final height = size.height - 400;
    return Scaffold(
        appBar: AppBar(title: Text(s.budget)),
        body: Observer(builder: (context) {
          syncStatus2.syncedHeight;
          return Column(
            children: [
              Panel(
                title: s.largestSpendingsByAddress,
                color: t.colorScheme.primary,
                child: Container(height: 130, child: BudgetChart()),
              ),
              Panel(
                  title: s.accountBalanceHistory,
                  color: t.colorScheme.secondary,
                  child: Container(
                    height: height,
                    child: Chart<TimeSeriesPoint<double>>(
                        data: active.accountBalances,
                        variables: {
                          'day': Variable<TimeSeriesPoint<double>, DateTime>(
                              accessor: (data) =>
                                  DateTime.fromMillisecondsSinceEpoch(
                                      data.day * DAY_MS),
                              scale: TimeScale(
                                  formatter: (dt) =>
                                      chartDateFormat.format(dt))),
                          'balance': Variable<TimeSeriesPoint<double>, double>(
                              accessor: (data) => data.value),
                        },
                        marks: [
                          LineMark(),
                          AreaMark(
                            shape: ShapeEncode(
                                value: BasicAreaShape(smooth: true)),
                            color: ColorEncode(
                                value: Defaults.colors10.first.withAlpha(80)),
                          ),
                        ],
                        axes: [Defaults.horizontalAxis, Defaults.verticalAxis],
                        selections: {
                          'touchMove': PointSelection(
                            on: {
                              GestureType.scaleUpdate,
                              GestureType.tapDown,
                              GestureType.longPressMoveUpdate
                            },
                            dim: Dim.x,
                          )
                        },
                        tooltip: TooltipGuide(),
                        crosshair: CrosshairGuide()),
                  )),
            ],
          );
        }));
  }
}

class BudgetChart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BudgetChartState();
}

class _BudgetChartState extends State<BudgetChart> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      HorizontalBarChart(
          active.spendings.map((s) => s.amount / ZECUNIT).toList()),
      BudgetTable(active.spendings)
    ]);
  }
}

class BudgetTable extends StatelessWidget {
  final List<Spending> spendings;
  BudgetTable(this.spendings);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final palette = getPalette(t.primaryColor, spendings.length);
    final rows = spendings.asMap().entries.map((e) {
      final style = TextStyle(
          color: palette[e.key], fontFeatures: [FontFeature.tabularFigures()]);
      final recipient = e.value.recipient!;
      return TableRow(children: [
        Text(
          recipient,
          style: style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(decimalFormat(e.value.amount / ZECUNIT, 8), style: style)
      ]);
    }).toList();
    return Table(
        columnWidths: {0: FlexColumnWidth(), 1: IntrinsicColumnWidth()},
        children: rows);
  }
}

class Panel extends StatelessWidget {
  final String title;
  final Color? color;
  final Widget? child;
  Panel({required this.title, this.color, this.child});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Card(
      child: Column(
        children: [
          Text(title, style: t.textTheme.bodyLarge),
          SizedBox(height: 16),
          if (child != null) child!,
        ],
      ),
    );
  }
}