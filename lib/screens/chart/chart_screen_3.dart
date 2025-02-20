import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biểu đồ lượt truy cập")),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 50, title: "Web", color: Colors.blue, radius: 50),
              PieChartSectionData(value: 30, title: "Mobile", color: Colors.green, radius: 45),
              PieChartSectionData(value: 20, title: "Khác", color: Colors.grey, radius: 40),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
