import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:collegeadmissionhelper/services/dashboard_service.dart';
import 'package:intl/intl.dart';

import '../../models/login_stats_response.dart';

class ChartScreen1 extends StatefulWidget {
  @override
  _ChartScreen1State createState() => _ChartScreen1State();
}

class _ChartScreen1State extends State<ChartScreen1> {
  final DashboardService _dashboardService = DashboardService();
  LoginStatsResponse? _loginStats;
  bool _isLoading = true;
  String _errorMessage = '';
  int? _touchedIndex;

  // Default date range
  String _startDate = "03/01/2025 03:05 PM";
  late String _endDate; // Will be set to current date and time

  // Controllers for the text fields
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set _endDate to the current date and time
    final dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
    _endDate = dateFormat.format(DateTime.now());
    // Initialize the text field controllers
    _updateDateControllers();
    _fetchLoginStats();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateDateControllers() {
    final displayFormat = DateFormat("dd/MM/yyyy");
    _startDateController.text = displayFormat.format(
        DateFormat("dd/MM/yyyy hh:mm a").parse(_startDate));
    _endDateController.text = displayFormat
        .format(DateFormat("dd/MM/yyyy hh:mm a").parse(_endDate));
  }

  Future<void> _fetchLoginStats() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final stats = await _dashboardService.getUserLoginStats(
        _startDate,
        _endDate,
      );
      setState(() {
        _loginStats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
    final currentStartDate = dateFormat.parse(_startDate);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentStartDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select start date',
      confirmText: 'Confirm',
      cancelText: 'Cancel',
    );

    if (pickedDate == null) return; // User canceled the picker

    // Set the time to 00:00 for the start date
    final DateTime newStartDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      0, // 00:00
      0,
    );

    setState(() {
      _startDate = dateFormat.format(newStartDate);
      _updateDateControllers();
    });
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final dateFormat = DateFormat("dd/MM/yyyy hh:mm a");
    final currentEndDate = dateFormat.parse(_endDate);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentEndDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: 'Select end date',
      confirmText: 'Confirm',
      cancelText: 'Cancel',
    );

    if (pickedDate == null) return; // User canceled the picker

    // Set the time to 23:59 for the end date
    final DateTime newEndDate = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      23, // 23:59
      59,
    );

    setState(() {
      _endDate = dateFormat.format(newEndDate);
      _updateDateControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login statistics chart"),
      ),
      body: Column(
        children: [
          // Date selection fields and button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start date field
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _startDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Start date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectStartDate(context),
                  ),
                ),
                SizedBox(width: 16),
                // End date field
                SizedBox(
                  width: 120,
                  child: TextFormField(
                    controller: _endDateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'End date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () => _selectEndDate(context),
                  ),
                ),
                SizedBox(width: 16),
                // Button to fetch data
                ElevatedButton(
                  onPressed: _fetchLoginStats,
                  child: Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : _errorMessage.isNotEmpty
                      ? Text(_errorMessage,
                          style: TextStyle(color: Colors.red))
                      : _buildChartWithInfo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartWithInfo() {
    if (_loginStats == null || _loginStats!.data.values.isEmpty) {
      return Text("No data to display");
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Display the login count when a section is touched
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _touchedIndex != null && _touchedIndex! >= 0
                ? 'Number of logins ${_loginStats!.data.values[_touchedIndex!].userName}: ${_loginStats!.data.values[_touchedIndex!].loginCount}'
                : 'Tap a section to see the number of logins',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        // Pie chart
        SizedBox(
          height: 300,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      _touchedIndex = null;
                      return;
                    }
                    _touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              sections: _buildSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    final data = _loginStats!.data.values;
    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final value = item.loginCount.toDouble();
      final title = item.userName;
      final colors = [Colors.blue, Colors.red, Colors.green, Colors.orange];
      final isTouched = index == _touchedIndex;

      return PieChartSectionData(
        value: value,
        title: title,
        color: colors[index % colors.length],
        radius: isTouched ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: isTouched ? 16 : 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}