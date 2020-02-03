import 'package:demo_flutter_charts/basic_chart.dart';
import 'package:demo_flutter_charts/dis_chart.dart';
import 'package:demo_flutter_charts/min_max_chart.dart';
import 'package:demo_flutter_charts/mix_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
      length: 4,
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BasicChart(),
            MinMaxChart(),
            MixChart(),
            DisChart(),
          ],
        ),
      ),
    );
  }
}
