import 'dart:collection';
import 'dart:math';

import 'package:demo_flutter_charts/time_series_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BezierChart extends StatefulWidget {
  BezierChart({Key key, this.isSmooth}) : super(key: key);

  final bool isSmooth;

  @override
  _BezierChart createState() => _BezierChart();
}

class _BezierChart extends State<BezierChart> {
  List<TimeSeriesData> tsdatasnow = [];
  List<TimeSeriesData> tsdatatemp = [];

  @override
  void initState() {
    var random = Random();
    double val = (random.nextDouble() * 120) + 50;

    for (int i = 12; i > 0; i--) {
      var date = DateTime.now().subtract(Duration(hours: (i * 12) - (3 * random.nextDouble()).toInt()));

      double evol = (random.nextDouble() * 10);
      if (random.nextBool() == true) evol = evol * -1;
      val = val + evol;
      tsdatasnow.add(TimeSeriesData(date, val));

      double val2 = (random.nextDouble() * 20) - 15;
      tsdatatemp.add(TimeSeriesData(date, val2));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var seriesChart = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'snow',
        displayName: "Neige",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatasnow,
      )..setAttribute(charts.measureAxisIdKey, 'axis 1'),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Temperature',
        displayName: "Température",
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatatemp,
      )..setAttribute(charts.measureAxisIdKey, 'axis 2'),
    ];

    return Container(
      child: charts.TimeSeriesChart(
        seriesChart,
        animate: false,
        defaultRenderer: charts.LineRendererConfig(
          smoothLine: widget.isSmooth,
        ),
        animationDuration: Duration(milliseconds: 800),
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            showMeasures: true,
            horizontalFirst: true,
            measureFormatter: (num value) {
              return value == null ? '' : '${value.toStringAsFixed(0)}';
            },
          ),
        ],
        disjointMeasureAxes: LinkedHashMap<String, charts.NumericAxisSpec>.from({
          'axis 1': charts.NumericAxisSpec(),
          'axis 2': charts.NumericAxisSpec(),
        }),
        layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(30),
            topMarginSpec: charts.MarginSpec.fixedPixel(30),
            rightMarginSpec: charts.MarginSpec.fixedPixel(30),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(10)),
        domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM'),
          ),
        ),
      ),
    );
  }
}

class BezierChartView extends StatefulWidget {
  const BezierChartView({Key key}) : super(key: key);

  @override
  _BezierChartViewState createState() => _BezierChartViewState();
}

class _BezierChartViewState extends State<BezierChartView> {
  bool isSmooth = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('smooth: '),
            Switch(
              value: isSmooth,
              onChanged: (value) {
                setState(() {
                  isSmooth = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
            ),
          ],
        ),
        Expanded(
          child: BezierChart(
            isSmooth: isSmooth,
          ),
        )
      ],
    );
  }
}
