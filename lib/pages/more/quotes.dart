import 'package:flutter/material.dart';
import 'package:graphic/graphic.dart';
import 'package:warp_api/warp_api.dart';

import '../../generated/intl/messages.dart';
import '../../main.dart';
import '../../store.dart';
import 'budget.dart';

class MarketQuotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.marketPrice)),
      body: Chart<PnL>(
          data: active.pnls,
          variables: {
            'day': Variable<PnL, DateTime>(
                accessor: (data) => data.timestamp,
                scale:
                    TimeScale(formatter: (dt) => chartDateFormat.format(dt))),
            'price': Variable<PnL, double>(accessor: (data) => data.price),
          },
          marks: [
            LineMark(),
            AreaMark(
              shape: ShapeEncode(value: BasicAreaShape(smooth: true)),
              color: ColorEncode(value: Defaults.colors10.first.withAlpha(80)),
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
    );
  }
}