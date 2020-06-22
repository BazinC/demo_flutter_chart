import 'dart:collection';
import 'dart:core';
import 'dart:math';

import 'package:demo_flutter_charts/custom_legend_entry_builder.dart';
import 'package:demo_flutter_charts/time_series_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_cf/charts_flutter_cf.dart' as charts;

/// Copy of DisChart with custom legend
class CustomLegendChart extends StatefulWidget {
  CustomLegendChart({Key key}) : super(key: key);

  @override
  _CustomLegendChartState createState() => _CustomLegendChartState();
}

class _CustomLegendChartState extends State<CustomLegendChart> {
  List<TimeSeriesData> tsdatasnow = [];
  List<TimeSeriesData> tsdatatemp = [];

  @override
  void initState() {
    var random = Random();

    for (int i = 12; i > 0; i--) {
      var date = DateTime.now().subtract(Duration(hours: (i * 12) - (3 * random.nextDouble()).toInt()));

      double val = (random.nextDouble() * 30);

      tsdatasnow.add(TimeSeriesData(date, val));

      double val2 = (random.nextDouble() * 20);

      tsdatatemp.add(TimeSeriesData(date, val2));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var seriesChart = [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'mountainsnow',
        displayName: "Montagne",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatasnow,
      )..setAttribute(charts.measureAxisIdKey, 'axis 1'),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'valleysnow',
        displayName: "Vallée",
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.data,
        data: tsdatatemp,
      )..setAttribute(charts.measureAxisIdKey, 'axis 2'),
    ];

    return Container(
      child: charts.TimeSeriesChart(
        seriesChart,
        animate: true,
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
          // Customize the legend
          // disabled for now, not available yet on community version
          // charts.SeriesLegend.customLayoutAndEntryGenerator(CustomLegendContentBuilder(), CustomLegendEntryGenerator<DateTime>(),
          //     showMeasures: true, measureFormatter: (num value) => '${value?.toStringAsFixed(0)}'),
        ],
        disjointMeasureAxes: LinkedHashMap<String, charts.NumericAxisSpec>.from({
          'axis 1': charts.NumericAxisSpec(),
          'axis 2': charts.NumericAxisSpec(),
        }),
        layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(30),
            topMarginSpec: charts.MarginSpec.fixedPixel(30),
            rightMarginSpec: charts.MarginSpec.fixedPixel(30),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(30)),
        domainAxis: charts.DateTimeAxisSpec(
          tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
            day: charts.TimeFormatterSpec(format: 'd', transitionFormat: 'dd/MM'),
          ),
        ),
      ),
    );
  }
}
