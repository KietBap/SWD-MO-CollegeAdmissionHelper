import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Biểu đồ tư vấn AI")),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(value: 60, title: "Thành công", color: Colors.green, radius: 50),
              PieChartSectionData(value: 25, title: "Cần hỗ trợ thêm", color: Colors.yellow, radius: 45),
              PieChartSectionData(value: 15, title: "Không hữu ích", color: Colors.red, radius: 40),
            ],
            sectionsSpace: 2,
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
