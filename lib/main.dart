import 'package:demo_flutter_charts/basic_chart.dart';
import 'package:demo_flutter_charts/bezier_chart.dart';
import 'package:demo_flutter_charts/dis_chart.dart';
import 'package:demo_flutter_charts/min_max_chart.dart';
import 'package:demo_flutter_charts/mix_chart.dart';
import 'package:demo_flutter_charts/time_zone_aware_chart.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  // Initialize timezone database
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Flutter Chart',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo Flutter Chart'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Basic",
              ),
              Tab(
                text: "Min/max",
              ),
              Tab(
                text: "Mix",
              ),
              Tab(
                text: "Disjoint",
              ),
              Tab(
                text: "Bezier",
              ),
              Tab(
                text: "TimeZone",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BasicChart(),
            MinMaxChart(),
            MixChart(),
            DisChart(),
            BezierChartView(),
            TimeZoneAwareChartView(),
          ],
        ),
      ),
    );
  }
}
