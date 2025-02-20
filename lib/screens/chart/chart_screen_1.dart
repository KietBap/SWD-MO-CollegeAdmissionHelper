import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biểu đồ ngành học")),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 40, title: "CNTT", color: Colors.blue, radius: 50),
              PieChartSectionData(value: 30, title: "Kinh tế", color: Colors.red, radius: 45),
              PieChartSectionData(value: 20, title: "Y Dược", color: Colors.green, radius: 40),
              PieChartSectionData(value: 10, title: "Khác", color: Colors.orange, radius: 35),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
