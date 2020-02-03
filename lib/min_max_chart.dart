import 'dart:math';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MinMaxChart extends StatefulWidget {
  MinMaxChart({Key key}) : super(key: key);

  @override
  _MinMaxChart createState() => _MinMaxChart();
}

class _MinMaxChart extends State<MinMaxChart> {
  List<TimeSeriesData> tsdatatemperature = [];

  @override
  void initState() {
    var random = Random();

    for (int i = 0; i < 12; i++) {
      var date = DateTime.now().subtract(
          Duration(hours: (i * 12) - (3 * random.nextDouble()).toInt()));
      double val = (random.nextDouble() * 20) - 10;
      tsdatatemperature.add(TimeSeriesData(date, val,
          val - (8 * random.nextDouble()), val + (8 * random.nextDouble())));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var seriesTemperature = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Temperature',
        displayName: "Température",
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.temp,
        measureLowerBoundFn: (TimeSeriesData data, _) => data.tempMin,
        measureUpperBoundFn: (TimeSeriesData data, _) => data.tempMax,
        data: tsdatatemperature,
      ),
    ];

    return Container(
      child: charts.TimeSeriesChart(
        seriesTemperature,
        animate: true,
        animationDuration: Duration(milliseconds: 800),
        behaviors: [
          charts.SeriesLegend(
            position: charts.BehaviorPosition.bottom,
            showMeasures: true,
            horizontalFirst: false,
            measureFormatter: (num value) {
              return value == null ? '-' : '${value.toStringAsFixed(1)}°C';
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
                day: charts.TimeFormatterSpec(
                    format: 'd', transitionFormat: 'dd/MM'))),
      ),
    );
  }
}

class TimeSeriesData {
  final DateTime time;
  final double temp;
  final double tempMin;
  final double tempMax;
  TimeSeriesData(
    this.time,
    this.temp,
    this.tempMin,
    this.tempMax,
  );
}
