// disabled for now, not available yet on community version

// import 'package:charts_flutter/flutter.dart' hide Color;
// import 'package:charts_flutter/src/behaviors/legend/legend.dart';
// import 'dart:math' as math;

// import 'package:auto_size_text/auto_size_text.dart';
// import 'dart:ui' as ui;

// import 'package:charts_common/common.dart' as common;

// import 'package:flutter/material.dart';

// import 'dart:collection';

// import 'package:charts_common/src/chart/cartesian/axis/spec/axis_spec.dart';
// import 'package:charts_common/src/chart/common/behavior/legend/legend_entry.dart';
// import 'package:charts_common/src/chart/common/behavior/legend/legend_entry_generator.dart';
// import 'package:charts_common/src/chart/common/processed_series.dart';
// import 'package:charts_common/src/chart/common/selection_model/selection_model.dart';
// // import 'package:charts_flutter/flutter.dart';

// // TODO : split into files

// /// A Custom legend content builder inspired by TabularLegendContentBuilder from charts_flutter.
// /// It enables us to use our custom CustomLegendEntryLayout and CustomLegendLayout
// class CustomLegendContentBuilder extends LegendContentBuilder {
//   final LegendEntryLayout legendEntryLayout;
//   final LegendLayout legendLayout;

//   CustomLegendContentBuilder({LegendEntryLayout legendEntryLayout, LegendLayout legendLayout})
//       : legendEntryLayout = legendEntryLayout ?? CustomLegendEntryLayout(),
//         legendLayout = legendLayout ?? CustomLegendLayout();

//   @override
//   bool operator ==(Object o) {
//     return o is CustomLegendContentBuilder && legendEntryLayout == o.legendEntryLayout && legendLayout == o.legendLayout;
//   }

//   @override
//   int get hashCode => hashValues(legendEntryLayout, legendLayout);

//   @override
//   Widget build(BuildContext context, common.LegendState legendState, common.Legend legend, {bool showMeasures}) {
//     final entryWidgets = legendState.legendEntries.map((entry) {
//       var isHidden = false;
//       if (legend is common.SeriesLegend) {
//         isHidden = legend.isSeriesHidden(entry.series.id);
//       }

//       return legendEntryLayout.build(context, entry, legend as TappableLegend, isHidden, showMeasures: showMeasures);
//     }).toList();

//     return legendLayout.build(context, entryWidgets);
//   }
// }

// class CustomLegendLayout implements LegendLayout {
//   static const double kChartLegendHeight = 100;

//   @override
//   Widget build(BuildContext context, List<Widget> legendEntryWidgets) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5),
//       // TODO : find a better Layout for legend section.
//       // This layout is passed to a CustomMultiChildLayout managed by the chart lib.
//       child: SizedBox(
//         height: kChartLegendHeight,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: legendEntryWidgets,
//         ),
//       ),
//     );
//   }
// }

// class CustomLegendEntryLayout implements LegendEntryLayout {
//   // TODO : try to add gesture management like SimpleLegendEntryLayout (from charts_flutter) do.
//   @override
//   Widget build(BuildContext context, common.LegendEntry legendEntry, TappableLegend legend, bool isHidden, {bool showMeasures}) {
//     final color = ColorUtil.toDartColor(
//       legendEntry.color,
//     );
//     final title = legendEntry.label;
//     const TextStyle titleStyle = TextStyle(color: Colors.deepPurple);
//     final AutoSizeGroup legendEntryLabelAutoSizeGroup = AutoSizeGroup();

//     return Flexible(
//       fit: FlexFit.tight,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         mainAxisSize: MainAxisSize.max,
//         children: <Widget>[
//           Flexible(
//             flex: 1,
//             fit: FlexFit.tight,
//             // fit: FlexFit.loose,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                     width: 6,
//                     height: 6,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                     )),
//                 const SizedBox(
//                   width: 1,
//                 ),
//                 Flexible(
//                     child: AutoSizeText(
//                   title,
//                   maxLines: 1,
//                   minFontSize: 5,
//                   style: titleStyle,
//                   group: legendEntryLabelAutoSizeGroup,
//                 )),
//               ],
//             ),
//           ),
//           ..._buildSubTitleFlexibles(legendEntry, color, 4, 1, titleStyle)
//         ],
//       ),
//     );
//   }

//   /// A generator function that generates Flexibles with details if details are available in the legendEntry.
//   /// If not, it generates equivalent Expanded widget to keep consistency.
//   Iterable<Widget> _buildSubTitleFlexibles(
//       common.LegendEntry legendEntry, Color circleColor, int circleFlex, int detailsFlex, TextStyle textStyle) sync* {
//     if (legendEntry.value != null && legendEntry.formattedValue != null) {
//       yield Flexible(
//         flex: circleFlex,
//         child: FittedBox(
//           fit: BoxFit.contain,
//           alignment: Alignment.bottomCenter,
//           child: CirclePercentageWidget(
//             size: 50,
//             percent: legendEntry.value,
//             color1: Colors.white,
//             color0: circleColor,
//             paintColor: Colors.grey,
//             labelStyle: textStyle,
//           ),
//         ),
//       );
//       yield Flexible(
//         flex: 1,
//         fit: FlexFit.tight,
//         child: FittedBox(
//           alignment: Alignment.center,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 3),
//                 child: Text(legendEntry.formattedValue, maxLines: 1, style: textStyle),
//               ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       yield Expanded(
//         flex: circleFlex + detailsFlex,
//         child: Container(),
//       );
//     }
//   }
// }

// class CirclePercentageWidget extends StatefulWidget {
//   final double size;
//   final double percent;
//   final Color color0;
//   final Color color1;
//   final Color paintColor;
//   final TextStyle labelStyle;

//   const CirclePercentageWidget(
//       {this.percent = 0.0, this.color0 = Colors.white, this.color1 = Colors.transparent, this.size, this.paintColor, this.labelStyle});

//   @override
//   State createState() => _CirclePercentageWidgetState();
// }

// class _CirclePercentageWidgetState extends State<CirclePercentageWidget> with SingleTickerProviderStateMixin {
//   AnimationController _controller;

//   @override
//   void initState() {
//     _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));

//     _controller.addListener(() {
//       setState(() {});
//     });

//     _controller.animateTo(widget.percent);

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(CirclePercentageWidget oldWidget) {
//     if (oldWidget.percent != widget.percent) {
//       _controller.animateTo(widget.percent);
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(context) {
//     return Container(
//       width: widget.size,
//       height: widget.size,
//       margin: const EdgeInsets.all(12),
//       child: CustomPaint(
//         isComplex: false,
//         painter: CirclePercentagePainter(_controller.value, widget.color0, widget.color1, widget.paintColor),
//         child: Center(child: Text('${(_controller.value * 100).round()}%', style: widget.labelStyle)),
//       ),
//     );
//   }
// }

// /// Inspired by the bank account app demo in "flutter vignettes"
// class CirclePercentagePainter extends CustomPainter {
//   final double percent;
//   final Color paintColor;
//   final Color color0;
//   final Color color1;

//   CirclePercentagePainter(this.percent, this.color0, this.color1, this.paintColor);

//   @override
//   void paint(canvas, size) {
//     final paint = Paint();
//     paint.color = paintColor;
//     paint.style = PaintingStyle.stroke;
//     paint.strokeWidth = 13;
//     paint.strokeCap = StrokeCap.butt;
//     final Offset center = Offset(size.width / 2, size.height / 2);
//     final rect = Rect.fromCircle(
//       center: center,
//       radius: size.width / 2,
//     );

//     paint.shader = ui.Gradient.radial(center, size.width, [color1, paintColor]);

//     canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), 0, math.pi * 2, false, paint);
//     paint.shader = ui.Gradient.radial(center, size.width, [color1, color0]);

//     canvas.drawArc(rect, -math.pi / 2, -2 * math.pi * percent, false, paint);
//   }

//   @override
//   bool shouldRepaint(CirclePercentagePainter oldCategory) {
//     return percent != oldCategory.percent || color0 != oldCategory.color0 || color1 != oldCategory.color1;
//   }
// }

// /// A custom legend entry generator that process selected value and its percentage for each legend entry.
// /// This custom class is inspired by PerSeriesLegendEntryGenerator from charts_common library.
// class CustomLegendEntryGenerator<D> implements LegendEntryGenerator<D> {
//   @override
//   TextStyleSpec entryTextStyle;
//   @override
//   MeasureFormatter measureFormatter;
//   @override
//   MeasureFormatter secondaryMeasureFormatter;
//   @override
//   bool showOverlaySeries = false; // Defaults to false.

//   /// Option for showing measures when there is no selection.
//   @override
//   LegendDefaultMeasure legendDefaultMeasure;

//   @override
//   List<LegendEntry<D>> getLegendEntries(List<MutableSeries<D>> seriesList) {
//     final legendEntries = seriesList
//         .where((series) => showOverlaySeries || !series.overlaySeries)
//         .map((series) => LegendEntry<D>(series, series.displayName, color: series.seriesColor, textStyle: entryTextStyle))
//         .toList();

//     // Update with measures only if showing measure on no selection.
//     if (legendDefaultMeasure != LegendDefaultMeasure.none) {
//       _updateFromSeriesList(legendEntries, seriesList);
//     }

//     return legendEntries;
//   }

//   @override
//   void updateLegendEntries(List<LegendEntry<D>> legendEntries, SelectionModel<D> selectionModel, List<MutableSeries<D>> seriesList) {
//     if (selectionModel.hasAnySelection) {
//       _updateFromSelection(legendEntries, selectionModel, seriesList);
//     } else {
//       // Update with measures only if showing measure on no selection.
//       if (legendDefaultMeasure != LegendDefaultMeasure.none) {
//         _updateFromSeriesList(legendEntries, seriesList);
//       } else {
//         _resetLegendEntryMeasures(legendEntries);
//       }
//     }
//   }

//   /// Update legend entries with measures of the selected datum
//   void _updateFromSelection(List<LegendEntry<D>> legendEntries, SelectionModel<D> selectionModel, List<MutableSeries<D>> seriesList) {
//     // TODO : make it as a formater parameter
//     String _printDuration(Duration duration) {
//       String twoDigitMinutes = duration.inMinutes.remainder(60).toTwoDigits();
//       String twoDigitSeconds = duration.inSeconds.remainder(60).toTwoDigits();
//       return '${duration.inHours.toTwoDigits()}:$twoDigitMinutes:$twoDigitSeconds';
//     }

//     // Map of series ID to the total selected measure value for that series.
//     final seriesAndMeasure = <String, num>{};

//     // Hash set of series ID's that use the secondary measure axis
//     final secondaryAxisSeriesIDs = HashSet<String>();

//     double calculatedTotal = 0;

//     for (SeriesDatum<D> selectedDatum in selectionModel.selectedDatum) {
//       final series = selectedDatum.series;
//       final seriesId = series.id;
//       final measure = series.measureFn(selectedDatum.index) ?? 0;
//       calculatedTotal += measure;
//       seriesAndMeasure[seriesId] = seriesAndMeasure.containsKey(seriesId) ? seriesAndMeasure[seriesId] + measure : measure;
//       if (series.getAttr(measureAxisIdKey) == common.Axis.secondaryMeasureAxisId) {
//         secondaryAxisSeriesIDs.add(seriesId);
//       }
//     }

//     for (var entry in legendEntries) {
//       final seriesId = entry.series.id;
//       final serieValue = seriesAndMeasure[seriesId].toDouble();
//       final double measureValue = calculatedTotal > 0 ? serieValue / calculatedTotal : 0.0;
//       final formattedValue = (serieValue == null) ? '' : '${serieValue.toStringAsFixed(0)} cm';

//       entry.value = measureValue;
//       entry.formattedValue = formattedValue;
//       entry.isSelected = selectionModel.selectedSeries.any((selectedSeries) => entry.series.id == selectedSeries.id);
//     }
//   }

//   void _resetLegendEntryMeasures(List<LegendEntry<D>> legendEntries) {
//     for (LegendEntry<D> entry in legendEntries) {
//       entry.value = null;
//       entry.formattedValue = null;
//       entry.isSelected = false;
//     }
//   }

//   /// Update each legend entry by calculating measure values in [seriesList].
//   ///
//   /// This method calculates the legend's measure value to show when there is no
//   /// selection. The type of calculation is based on the [legendDefaultMeasure]
//   /// value.
//   void _updateFromSeriesList(List<LegendEntry<D>> legendEntries, List<MutableSeries<D>> seriesList) {
//     // Helper function to sum up the measure values
//     num getMeasureTotal(MutableSeries<D> series) {
//       var measureTotal = 0.0;
//       for (var i = 0; i < series.data.length; i++) {
//         measureTotal += series.measureFn(i);
//       }
//       return measureTotal;
//     }

//     // Map of series ID to the calculated measure for that series.
//     final seriesAndMeasure = <String, double>{};
//     // Map of series ID and the formatted measure for that series.
//     final seriesAndFormattedMeasure = <String, String>{};

//     for (MutableSeries<D> series in seriesList) {
//       final seriesId = series.id;
//       num calculatedMeasure;

//       switch (legendDefaultMeasure) {
//         case LegendDefaultMeasure.sum:
//           calculatedMeasure = getMeasureTotal(series);
//           break;
//         case LegendDefaultMeasure.average:
//           calculatedMeasure = getMeasureTotal(series) / series.data.length;
//           break;
//         case LegendDefaultMeasure.firstValue:
//           calculatedMeasure = series.measureFn(0);
//           break;
//         case LegendDefaultMeasure.lastValue:
//           calculatedMeasure = series.measureFn(series.data.length - 1);
//           break;
//         case LegendDefaultMeasure.none:
//           // [calculatedMeasure] intentionally left null, since we do not want
//           // to show any measures.
//           break;
//       }

//       seriesAndMeasure[seriesId] = calculatedMeasure?.toDouble();
//       seriesAndFormattedMeasure[seriesId] = (series.getAttr(measureAxisIdKey) == common.Axis.secondaryMeasureAxisId)
//           ? secondaryMeasureFormatter(calculatedMeasure)
//           : measureFormatter(calculatedMeasure);
//     }

//     for (var entry in legendEntries) {
//       final seriesId = entry.series.id;

//       entry.value = seriesAndMeasure[seriesId];
//       entry.formattedValue = seriesAndFormattedMeasure[seriesId];
//       entry.isSelected = false;
//     }
//   }

//   @override
//   bool operator ==(Object other) {
//     return other is CustomLegendEntryGenerator &&
//         measureFormatter == other.measureFormatter &&
//         secondaryMeasureFormatter == other.secondaryMeasureFormatter &&
//         legendDefaultMeasure == other.legendDefaultMeasure &&
//         entryTextStyle == other.entryTextStyle;
//   }

//   @override
//   int get hashCode {
//     int hashcode = measureFormatter?.hashCode ?? 0;
//     hashcode = (hashcode * 37) + secondaryMeasureFormatter.hashCode;
//     hashcode = (hashcode * 37) + legendDefaultMeasure.hashCode;
//     hashcode = (hashcode * 37) + entryTextStyle.hashCode;
//     return hashcode;
//   }
// }

// extension NumExtensions on num {
//   String toTwoDigits() {
//     if (this >= 10) return '$this';
//     return '0$this';
//   }
// }
