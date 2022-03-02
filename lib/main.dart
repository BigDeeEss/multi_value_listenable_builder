import 'package:flutter/material.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Multi-ValueListenableBuilder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Demo(),
    ),
  );
}

class Demo extends StatefulWidget {
  Demo({Key? key}) : super(key: key);

  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  List<String> _labels = ['Red', 'Char'];
  List<ValueNotifier> _argb = [
    ValueNotifier(255), // Alpha
    ValueNotifier('b'), // Red
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Multi-ValueListenableBuilder Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50.0),
              child: MultiValueListenableBuilder(
                valueListenables: _argb,
                builder: (context, values, child) {
                  return Container(
                    decoration: ShapeDecoration(
                      shadows: [BoxShadow(blurRadius: 5)],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      color: Color.fromRGBO(
                        values[0],
                        50,
                        50,
                        1.0
                      ),
                    ),
                    height: 200,
                    width: 200,
                    child: Center(
                      child: Text(values[1])
                    ),
                  );
                },
              ),
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: Text(
                        _labels.elementAt(0),
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                    Slider(
                      value: _argb[0].value.toDouble(),
                      max: 255,
                      min: 0,
                      onChanged: (newValue) {
                        setState(() {
                          _argb[0].value = newValue.toInt();
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      _labels.elementAt(1),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Slider(
                      value: (_argb[1].value.codeUnitAt(0) - 97).toDouble(),
                      max: 25,
                      min: 0,
                      onChanged: (newValue) {
                        setState(() {
                          _argb[1].value = String.fromCharCode(newValue.toInt() + 97);
                        });
                      },
                    ),
                  ],
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}