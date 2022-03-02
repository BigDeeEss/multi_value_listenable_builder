//  Import flutter packages.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// [MultiValueWidgetBuilder] defines the form of callback required
/// by [MultiValueListenerBuilder].
typedef MultiValueWidgetBuilder =
    Widget Function(BuildContext context, List<dynamic> values, Widget? child);

/// [MultiValueListenerBuilder] takes multiple listenable objects,
/// formatted as a dynamic list, and rebuilds when any of the listenables
/// in said list change.
class MultiValueListenableBuilder extends StatefulWidget {
  const MultiValueListenableBuilder({
    Key? key,
    required this.valueListenables,
    required this.builder,
    this.child,
  })  : assert(valueListenables.length != 0),
        super(key: key);

  /// [valueListenables] defines list of listenable objects that this
  /// widget depends on in order to build.
  final List<ValueListenable<dynamic>> valueListenables;

  /// A [MultiValueWidgetBuilder] which builds a widget depending on
  /// the list of values associated with [valueListenables].
  final MultiValueWidgetBuilder builder;

  /// An optional widget argument which is independent of any of the values
  /// associated with [valueListenables].
  ///
  /// Useful for speeding up the build process.
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _MultiValueListenableBuilderState();
}

class _MultiValueListenableBuilderState extends State<MultiValueListenableBuilder> {
  late List<dynamic> values;

  @override
  void initState() {
    super.initState();
    values = [];
    for (int i = 0; i < widget.valueListenables.length; i++) {
      //  Initiate local variable [values] using values associated
      //  with the [widget.valueListenables].
      values.add(widget.valueListenables[i].value);
      //  Initiate a rebuild (using setState() method associated with
      //  StatefulWidget.
      widget.valueListenables[i].addListener(_valueChanged);
    }
  }

  @override
  void didUpdateWidget(MultiValueListenableBuilder oldWidget) {
    if (oldWidget.valueListenables != widget.valueListenables) {
      for (int i = 0; i < widget.valueListenables.length; i++) {
        oldWidget.valueListenables[i].removeListener(_valueChanged);
        values[i] = widget.valueListenables[i].value;
        widget.valueListenables[i].addListener(_valueChanged);
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.valueListenables.length; i++) {
      widget.valueListenables[i].removeListener(_valueChanged);
    }
    super.dispose();
  }

  //  Call setState method associated with StatefulWidget, updating all
  //  [values] using widget.valueListenables.
  void _valueChanged() {
    setState(() {
      for (int i = 0; i < widget.valueListenables.length; i++) {
        values[i] = widget.valueListenables[i].value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, values, widget.child);
  }
}
