import 'dart:collection';
import 'dart:math';

import 'package:demo_flutter_charts/time_series_data.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter_cf/charts_flutter_cf.dart' as charts;

// import 'package:charts_common_cf/charts_common_cf.dart' as common;

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimeZoneAwareChart extends StatefulWidget {
  TimeZoneAwareChart({Key key, this.location, this.tsdatasnow, this.tsdatatemp}) : super(key: ObjectKey(location));
  final tz.Location location;
  final List<TimeSeriesData> tsdatasnow;
  final List<TimeSeriesData> tsdatatemp;

  @override
  _TimeZoneAwareChartState createState() => _TimeZoneAwareChartState();
}

class _TimeZoneAwareChartState extends State<TimeZoneAwareChart> {
  List<TimeSeriesData> tsdatasnow = [];
  List<TimeSeriesData> tsdatatemp = [];

  @override
  void initState() {
    tsdatasnow = widget.tsdatasnow;
    tsdatatemp = widget.tsdatatemp;
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
        disjointMeasureAxes: LinkedHashMap<String, charts.NumericAxisSpec>.from({
          'axis 1': charts.NumericAxisSpec(),
          'axis 2': charts.NumericAxisSpec(),
        }),
        layoutConfig: charts.LayoutConfig(
            leftMarginSpec: charts.MarginSpec.fixedPixel(30),
            topMarginSpec: charts.MarginSpec.fixedPixel(30),
            rightMarginSpec: charts.MarginSpec.fixedPixel(30),
            bottomMarginSpec: charts.MarginSpec.fixedPixel(30)),
        // disabled for now, not available yet on community version
        // dateTimeFactory: common.TimeZoneAwareDateTimeFactory(widget.location),
      ),
    );
  }
}

class TimeZoneAwareChartView extends StatefulWidget {
  const TimeZoneAwareChartView({Key key}) : super(key: key);

  @override
  _TimeZoneAwareChartViewState createState() => _TimeZoneAwareChartViewState();
}

class _TimeZoneAwareChartViewState extends State<TimeZoneAwareChartView> {
  tz.Location location;
  List<tz.Location> availableLocations;
  int offsetTimezone;
  static const millisecondsInAnHour = 3600000;
  List<TimeSeriesData> tsdatasnow = [];
  List<TimeSeriesData> tsdatatemp = [];

  void initState() {
    // Generate fake temperature data for the last
    var random = Random();
    double val = (random.nextDouble() * 120) + 50;
    final now = DateTime.now();
    final nowRoundedHour = DateTime.utc(now.year, now.month, now.day, now.hour);
    for (int i = 24; i > 0; i--) {
      var date = nowRoundedHour.subtract(Duration(hours: i));

      double evol = (random.nextDouble() * 10);
      if (random.nextBool() == true) evol = evol * -1;
      val = val + evol;
      tsdatasnow.add(TimeSeriesData(date, val));

      double val2 = (random.nextDouble() * 20) - 15;
      tsdatatemp.add(TimeSeriesData(date, val2));
    }

    location = tz.getLocation('Europe/Paris');
    offsetTimezone = location.currentTimeZone.offset;
    availableLocations = tz.timeZoneDatabase.locations.values.toList()..sort((a, b) => a.currentTimeZone.offset - b.currentTimeZone.offset);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Timezone: '),
              Flexible(
                child: DropdownButton<tz.Location>(
                    isExpanded: true,
                    value: location,
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                    ),
                    onChanged: (tz.Location newValue) {
                      setState(() {
                        location = newValue;
                      });
                    },
                    items: availableLocations
                        .map(
                          (location) => DropdownMenuItem<tz.Location>(
                              value: location,
                              child: Text(
                                'UTC${(location.currentTimeZone.offset < 0) ? '' : '+'}${location.currentTimeZone.offset / millisecondsInAnHour} ${location.name}',
                                textAlign: TextAlign.left,
                              )),
                        )
                        .toList()),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('UTC ofsset: '),
              Expanded(
                child: Slider(
                  value: offsetTimezone.toDouble(),
                  onChanged: (newValue) {
                    setState(() {
                      offsetTimezone = newValue.floor();
                      location = availableLocations.firstWhere((loc) => loc.currentTimeZone.offset == offsetTimezone, orElse: () => location);
                    });
                  },
                  min: -11.0 * millisecondsInAnHour,
                  max: 14.0 * millisecondsInAnHour,
                  divisions: 25,
                  label: '${(offsetTimezone / millisecondsInAnHour).toDouble()}',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TimeZoneAwareChart(
            location: location,
            tsdatasnow: tsdatasnow,
            tsdatatemp: tsdatatemp,
          ),
        )
      ],
    );
  }
}
