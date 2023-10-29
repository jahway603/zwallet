import 'dart:math';

import 'package:YWallet/appsettings.dart';
import 'package:YWallet/main.dart';
import 'package:YWallet/pages/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_palette/flutter_palette.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:warp_api/data_fb_generated.dart';
import 'package:warp_api/warp_api.dart';

import '../../accounts.dart';
import '../../generated/intl/messages.dart';
import '../settings.dart';

class PoolTransferPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PoolTransferState();
}

class _PoolTransferState extends State<PoolTransferPage> {
  final amountKey = GlobalKey<InputAmountState>();
  final memoController = TextEditingController(text: appSettings.memo);
  final splitController = TextEditingController(text: amountToString2(0));
  late final List<double> balances;
  int from = 0;
  int to = 1;
  bool calculatingPlan = false;

  @override
  void initState() {
    super.initState();
    final pb = aa.poolBalances;
    balances = [pb.transparent, pb.sapling, pb.orchard]
        .map((b) => b / ZECUNIT)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final spendable = aa.poolBalances.get(from);
    final a = AmountState(amount: 0, spendable: spendable);
    return Scaffold(
      appBar: AppBar(
          title: Text(s.poolTransfer),
          actions: [IconButton(onPressed: ok, icon: Icon(Icons.check))]),
      body: SingleChildScrollView(
        child: LoadingWrapper(
          calculatingPlan,
          child: FormBuilder(
            child: Column(
              children: [
                HorizontalBarChart(balances),
                FieldUARadio(from,
                    name: 'from',
                    label: s.fromPool,
                    onChanged: (v) => setState(() {
                          from = v!;
                        })),
                FieldUARadio(to,
                    name: 'to',
                    label: s.toPool,
                    onChanged: (v) => setState(() {
                          to = v!;
                        })),
                SizedBox(height: 16),
                InputAmountWidget(a, key: amountKey),
                SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'memo',
                  decoration: InputDecoration(label: Text(s.memo)),
                  controller: memoController,
                  maxLines: 10,
                ),
                FormBuilderTextField(
                    name: 'split',
                    decoration:
                        InputDecoration(label: Text(s.maxAmountPerNote)),
                    controller: splitController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.numeric(),
                      FormBuilderValidators.min(0, inclusive: false),
                    ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  ok() async {
    final amount = amountKey.currentState?.amount;
    if (amount == null) return;
    final splitAmount = stringToAmount(splitController.text);
    _calc(true);
    final plan = await WarpApi.transferPools(
          aa.coin,
          aa.id,
          1 << from,
          1 << to,
          amount,
          false,
          memoController.text,
          splitAmount,
          appSettings.anchorOffset,
          coinSettings.feeT,
        );
    _calc(false);
    GoRouter.of(context).push('/account/txplan', extra: plan);
  }

  _calc(bool v) => setState(() => calculatingPlan = v);
}

class HorizontalBarChart extends StatelessWidget {
  final List<double> values;
  final double height;

  HorizontalBarChart(this.values, {this.height = 32});

  @override
  Widget build(BuildContext context) {
    final palette = getPalette(Theme.of(context).primaryColor, values.length);

    final sum = values.fold<double>(0, ((acc, v) => acc + v));
    final stacks = values.asMap().entries.map((e) {
      final i = e.key;
      final color = palette[i];
      final v = NumberFormat.compact().format(values[i]);
      final flex = sum != 0 ? max((values[i] / sum * 100).round(), 1) : 1;
      return Flexible(
          child: Container(
              child: Center(
                  child: Text(v,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white))),
              color: color,
              height: height),
          flex: flex);
    }).toList();

    return IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch, children: stacks));
  }
}

ColorPalette getPalette(Color color, int n) => ColorPalette.polyad(
      color,
      numberOfColors: max(n, 1),
      hueVariability: 15,
      saturationVariability: 10,
      brightnessVariability: 10,
    );

extension PoolBalanceExtension on PoolBalanceT {
  int get(int p) {
    switch (p) {
      case 0:
        return transparent;
      case 1:
        return sapling;
      case 2:
        return orchard;
    }
    throw 'Invalid pool';
  }
}