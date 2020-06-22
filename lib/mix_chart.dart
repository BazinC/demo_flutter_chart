import 'dart:math';

import 'package:demo_flutter_charts/time_series_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_cf/charts_flutter_cf.dart' as charts;

class MixChart extends StatefulWidget {
  MixChart({Key key}) : super(key: key);

  @override
  _MixChartState createState() => _MixChartState();
}

class _MixChartState extends State<MixChart> {
  List<TimeSeriesData> tsdatasnow = [];
  List<TimeSeriesData> tsdatanewsnow = [];

  @override
  void initState() {
    var random = Random();
    double val = (random.nextDouble() * 120) + 50;
    double valNew = 0;

    for (int i = 12; i > 0; i--) {
      var date = DateTime.now().subtract(Duration(hours: (i * 12) - (3 * random.nextDouble()).toInt()));
      if (random.nextDouble() > 0.75) {
        valNew = (random.nextDouble() * 30) + 10;
        tsdatanewsnow.add(TimeSeriesData(date, valNew));
        val = val + valNew;
      } else {
        valNew = 0;
        double fonte = (random.nextDouble() * 10);
        val = val - fonte;
      }

      tsdatasnow.add(TimeSeriesData(date, val));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var seriesSnow = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'snow',
        displayName: "Neige",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatasnow,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'SnowNewHeight',
        displayName: "Neige fraîche",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatanewsnow,
      )..setAttribute(charts.rendererIdKey, 'customBar'),
    ];

    return Container(
      child: charts.TimeSeriesChart(
        seriesSnow,
        animate: true,
        animationDuration: Duration(milliseconds: 800),
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            showMeasures: true,
            horizontalFirst: false,
            measureFormatter: (num value) {
              return value == null ? '-' : '${value.toStringAsFixed(0)}cm';
            },
          ),
        ],
        layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(30),
            topMarginSpec: charts.MarginSpec.fixedPixel(10),
            rightMarginSpec: charts.MarginSpec.fixedPixel(10),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
        domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM'),
          ),
        ),
        customSeriesRenderers: [
          charts.BarRendererConfig(
              // ID used to link series to this renderer.
              customRendererId: 'customBar',
              cornerStrategy: const charts.ConstCornerStrategy(30),
              fillPattern: charts.FillPatternType.forwardHatch),
        ],
      ),
    );
  }
}
