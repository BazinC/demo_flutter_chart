import 'dart:math';

import 'package:demo_flutter_charts/time_series_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_cf/charts_flutter_cf.dart' as charts;

class BasicChart extends StatefulWidget {
  BasicChart({Key key}) : super(key: key);

  @override
  _BasicChartState createState() => _BasicChartState();
}

class _BasicChartState extends State<BasicChart> {
  List<TimeSeriesData> tsdatatemperature = [];
  List<TimeSeriesData> tsdatatemperatureground = [];

  @override
  void initState() {
    var random = Random();

    for (int i = 0; i < 12; i++) {
      var date = DateTime.now().subtract(Duration(hours: (i * 12) - (3 * random.nextDouble()).toInt()));
      double val = (random.nextDouble() * 30) - 15;
      tsdatatemperature.add(TimeSeriesData(date, val));

      double val2 = (random.nextDouble() * 10) - 10;
      tsdatatemperatureground.add(TimeSeriesData(date, val2));
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
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatatemperature,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Temperature Sol',
        displayName: "Température Sol",
        colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatatemperatureground,
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
            tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM'))),
      ),
    );
  }
}
