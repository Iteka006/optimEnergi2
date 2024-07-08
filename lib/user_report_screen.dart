import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UserReportScreen extends StatelessWidget {
  final String userId;

  UserReportScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Report'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.hasError) {
              return Center(child: Text('Error: ${userSnapshot.error}'));
            }
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            var userData = userSnapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${userData['firstName']} ${userData['lastName']}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text('Meter Number: ${userData['meterNumber']}'),
                  SizedBox(height: 20),
                  Text(
                    'Energy Usage Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await _downloadReport(context, userId, userData);
                    },
                    child: Text('Download Report'),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('energy_usage')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return Center(child: Text('No energy usage data found.'));
                        }

                        return ListView(
                          children: snapshot.data!.docs.map((doc) {
                            var usageData = doc.data() as Map<String, dynamic>;
                            return ListTile(
                              title: Text('Date: ${(usageData['date'] as Timestamp).toDate().toLocal().toString().split(' ')[0]}'),
                              subtitle: Text('Usage: ${usageData['usage']} kWh\nStatus: ${usageData['usage'] > 400 ? 'ABNORMAL' : 'NORMAL'}'),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _downloadReport(BuildContext context, String userId, Map<String, dynamic> userData) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('energy_usage')
          .get();

      List<List<dynamic>> rows = [
        ['Date', 'Usage (kWh)', 'Status']
      ];

      for (var doc in querySnapshot.docs) {
        var usageData = doc.data() as Map<String, dynamic>;
        var date = (usageData['date'] as Timestamp).toDate().toLocal().toString().split(' ')[0];
        var usage = usageData['usage'];
        var status = usage > 400 ? 'ABNORMAL' : 'NORMAL';
        rows.add([date, usage, status]);
      }

      String csv = const ListToCsvConverter().convert(rows);

      String filename = "${userData['firstName']}_${userData['lastName']}_Energy_Report.csv";
      Uint8List csvBytes = Uint8List.fromList(csv.codeUnits);

      if (kIsWeb) {
        final blob = html.Blob([csvBytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", filename)
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        if (await Permission.storage.request().isGranted) {
          final directory = await getExternalStorageDirectory();
          final path = directory?.path;
          final file = File('$path/$filename');

          await file.writeAsBytes(csvBytes);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Report downloaded successfully.'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Storage permission is required to download the report.'),
            backgroundColor: Colors.red,
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error downloading report: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
