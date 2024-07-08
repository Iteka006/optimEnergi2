import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class ReportPageWeb extends StatefulWidget {
  final String userId;
  final List<Map<String, dynamic>> usageData;

  ReportPageWeb({required this.userId, required this.usageData});

  @override
  _ReportPageWebState createState() => _ReportPageWebState();
}

class _ReportPageWebState extends State<ReportPageWeb> {
  DateTime _selectedDate = DateTime.now();
  double _energyUsage = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchDailyEnergyUsage(_selectedDate);
  }

  Future<void> _fetchDailyEnergyUsage(DateTime date) async {
    DateTime startOfDay = DateTime(date.year, date.month, date.day);
    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('energy_usage')
        .where('date', isGreaterThanOrEqualTo: startOfDay)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .get();

    double totalUsage = 0;
    snapshot.docs.forEach((doc) {
      totalUsage += doc['usage'];
    });

    setState(() {
      _energyUsage = totalUsage;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchDailyEnergyUsage(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Energy Usage Report'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Energy Usage: ${_energyUsage.toStringAsFixed(2)} kWh',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.usageData.length,
                itemBuilder: (context, index) {
                  var usage = widget.usageData[index];
                  return ListTile(
                    title: Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(usage['date'])}',
                      style: TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      'Usage: ${usage['kwh']} kWh\nCondition: ${usage['condition']}',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
