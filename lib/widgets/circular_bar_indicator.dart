import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircularBarIndicator extends StatelessWidget {
  final double percent;
  final String title;

   CircularBarIndicator({
    required this.percent,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: const AxisLineStyle(
            thickness: 0.15,
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.white,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: percent,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Internal Storage",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    Text(
                      percent.toInt().toString()+"%",
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
            )
          ]),
    ]);
  }
}
