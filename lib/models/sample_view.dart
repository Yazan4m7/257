/// Package import
import 'package:flutter/material.dart';


/// Base class of the sample's stateful widget class
abstract class SampleView extends StatefulWidget {
  /// base class constructor of sample's stateful widget class
  const SampleView({Key? key}) : super(key: key);
}

/// Base class of the sample's state class
abstract class SampleViewState<T extends SampleView> extends State<T> {
  /// Holds the SampleModel information


  /// Holds the information of current page is card view or not
  late bool isCardView;

  @override
  void initState() {
    super.initState();
  }

  /// Must call super.
  @override
  void dispose() {

    super.dispose();
  }

  /// Get the settings panel content.
  Widget? buildSettings(BuildContext context) {
    return null;
  }
}

/// Base class of the localization sample's stateful widget class
class LocalizationSampleView extends SampleView {
  /// base class constructor of sample's stateful widget class
  const LocalizationSampleView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LocalizationSampleViewState();
}

/// Base class of the localization sample's state class
class LocalizationSampleViewState<T extends LocalizationSampleView>
    extends SampleViewState<T> {
  late List<Locale> _supportedLocales;

  @override
  void initState() {
    if (this is! DirectionalitySampleViewState) {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
        const Locale('es', 'ES'),
        const Locale('fr', 'FR'),
        const Locale('zh', 'CN')
      ];
    } else {
      _supportedLocales = <Locale>[
        const Locale('ar', 'AE'),
        const Locale('en', 'US'),
      ];
    }

    super.initState();
  }



  Widget _buildDirectionalityWidget() {
    return Localizations(
        locale: Locale('AE'),
        delegates: [],
        child: Directionality(
            textDirection: TextDirection.ltr,
            child: buildSample(context) ?? Container()));
  }

  /// Method to get the widget's color based on the widget state
  Color? getColor(Set<WidgetState> states) {
    const Set<WidgetState> interactiveStates = <WidgetState>{
      WidgetState.pressed,
      WidgetState.selected,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return _buildDirectionalityWidget();
  }

  /// Get the settings panel content.
  Widget? buildSample(BuildContext context) {
    return null;
  }

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }
}

/// Base class of the directionality sample's stateful widget class
class DirectionalitySampleView extends LocalizationSampleView {
  /// base class constructor of sample's stateful widget class
  const DirectionalitySampleView({Key? key}) : super(key: key);
}

/// Base class of the directionality sample's state class
class DirectionalitySampleViewState<T extends DirectionalitySampleView>
    extends LocalizationSampleViewState<T> {
  final List<TextDirection> _supportedTextDirection = <TextDirection>[
    TextDirection.ltr,
  ];

  /// Must call super.
  @override
  void dispose() {
    super.dispose();
  }

  /// Close all overlay when property panel is opened. Implemented for PdfViewer
  /// RTL sample.
  void closeAllOverlay() {}

  /// Add the localization selection widget.

}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}