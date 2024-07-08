import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminNotificationPage extends StatefulWidget {
  @override
  _AdminNotificationPageState createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  // Location variables
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedSector;
  String? _selectedCell;
  String? _selectedVillage;
  String? _selectedTarget;

  // Dropdown options
  List<String> _provinces = ['Kigali', 'East', 'North', 'West', 'South'];
  Map<String, List<String>> _districts = {
    'Kigali': ['Gasabo', 'Kicukiro', 'Nyarugenge'],
    'East': ['Bugesera', 'Gatsibo', 'Kayonza', 'Kirehe', 'Ngoma', 'Nyagatare', 'Rwamagana'],
    'North': ['Burera', 'Gakenke', 'Gacumbi', 'Musanze', 'Rulindo'],
    'South': ['Gisagara', 'Huye', 'Kamonyi', 'Muhanga', 'Nyamagabe', 'Nyanza', 'Nyaruguru', 'Ruhango'],
    'West': ['Karongi', 'Ngororero', 'Nyabihu', 'Nyamasheke', 'Rubavu', 'Rusizi', 'Rutsiro'],
  };
  Map<String, List<String>> _sectors = {};
  Map<String, List<String>> _cells = {};
  Map<String, List<String>> _villages = {};
  List<String> _targets = ['All Users', 'Specific Location'];

  @override
  void initState() {
    super.initState();
    _updateDropdownOptions();
  }

  void _updateDropdownOptions() {
    _districts['Kigali'] = ['Gasabo', 'Kicukiro', 'Nyarugenge']; // Example data, replace with actual data
    _districts['East'] = ['Bugesera', 'Gatsibo', 'Kayonza', 'Kirehe', 'Ngoma', 'Nyagatare', 'Rwamagana']; 
    _districts['North'] = ['Burera', 'Gakenke', 'Gacumbi', 'Musanze', 'Rulindo']; // Example data, replace with actual data
    _districts['South'] = ['Gisagara', 'Huye', 'Kamonyi', 'Muhanga', 'Nyamagabe', 'Nyanza', 'Nyaruguru', 'Ruhango']; 
   _districts['West'] = ['Karongi', 'Ngororero', 'Nyabihu', 'Nyamasheke', 'Rubavu', 'Rusizi', 'Rutsiro']; 
    _sectors['Gasabo'] = ['Bumbogo', 'Gatsata', 'Gikomero', 'Gisozi', 'Jabana', 'Jali', 'Kacyiru', 'Kimihurura', 'Kimironko', 'Kinyinya', 'Ndera', 'Nduba', 'Remera', 'Rusororo', 'Rutunga']; // Example data, replace with actual data
    _sectors['Nyarugenge'] = ['Gitega', 'Kanyinya', 'Kigali', 'Kimmisagara', 'Mageragere', 'Kimisagara', 'Muhima', 'Nyakabanda']; // Example data, replace with actual data
    _sectors['Kicukiro'] = ['Gahanga', 'Gatenga', 'Gikondo', 'Kagarama', 'Kanombe', 'Kicukiro', 'Niboye']; // Example data, replace with actual data
    _sectors['Bugesera'] = ['Gashora', 'Juru', 'Kamabuye', 'Mareba', 'Mayange', 'Musenyi']; // Example data, replace with actual data
    _sectors['Gatsibo'] = ['Gasange', 'Gatsibo', 'Gitoki', 'Kabarore', 'Kageyo', 'Kiramuruzi', 'Kiziguro', 'Muhura', 'Murambi']; 
   _sectors['Burera'] = ['Bungwe', 'Butaro', 'Cyanika', 'Cyeru', 'Gahunga', 'Gatebe']; 
    _sectors['Gakenke'] = ['Busengo', 'Coko', 'Cyabingo', 'Gakenke', 'Gashenyi', 'Janja']; 
     _sectors['Gisagara'] = ['Gikonko', 'Gishubi', 'Kansi', 'Kabirizi', 'Kigembe', 'Mamba']; 
      _sectors['Huye'] = ['Gishamvu', 'Huye', 'Karama', 'Kigoma', 'Kinazi', 'Maraba']; 
        _sectors['Karongi'] = ['Bwishyura', 'Gashari', 'Gishyita', 'Gitesi', 'Mubuga', 'Murambi']; 
          _sectors['Ngororero'] = ['Bwira', 'Gatumba', 'Hindiro', 'Kabaya', 'Kageyo', 'Kavumu']; 
    _cells['Gashora'] = ['Biryogo', 'Kabuye', 'Kagomasi', 'Mwendo', 'Ramiro']; // Example data, replace with actual data
    _cells['Juru'] = ['Juru', 'Kabukuba', 'Mugorore', 'Musovu', 'Rwinume']; // Example data, replace with actual data
    _cells['Bumbogo'] = ['Kinyaga', 'Musave', 'Mvuzo', 'Ngara', 'Nkuzuzu', 'Nyabikenke']; // Example data, replace with actual data
    _cells['Gatsata'] = ['Karuruma', 'Nyamabuye', 'Nyamugari']; // Example data, replace with actual data
    _cells['Kacyiru'] = ['Kamatamu', 'Kamutwa', 'Kibaza']; // Example data, replace with actual data
    _cells['Kimironko'] = ['Bibare', 'Kibagabaga', 'Nyagatovu']; // Example data, replace with actual data
    _cells['Kimihurura'] = ['Kamukina', 'Kimihurura', 'Rugando'];
    _cells['Kanombe'] = ['Busanza', 'Kabeza', 'Karama', 'Rubirizi']; // Example data, replace with actual data
    _cells['Kagarama'] = ['Kanserege', 'Muyange', 'Rukatsa'];
    _cells['Niboye'] = ['Gatare', 'Niboye', 'Nyakabanda']; 
    _cells['Gitega'] = ['Akabahizi', 'Akabeza', 'Gacyamo', 'Kigarama'];
    _cells['Kinyinya'] = ['Nyamweru', 'Nzove', 'Taba'];
    _cells['Bungwe'] = ['Bungwe', 'Bushenya', 'Mudugari', 'Tumba'];
    _cells['Butaro'] = ['Gatsibo', 'Mubuga', 'Muhotora', 'Nyamicucu', 'Rusomo'];
    _cells['Gikonko'] = ['Cyiri', 'Gasagara', 'Gikonko', 'Mbogo'];
    _cells['Gishubi'] = ['Gabiro', 'Nyabitare', 'Nyakibungo', 'Nyeranzi'];// Example data, replace with actual data
    _cells['Bwishyura'] = ['Burunga', 'Gasura', 'Gitarama', 'Kayenzi'];
    _cells['Gashari'] = ['Birambo', 'Musasa', 'Mwendo', 'Rugobagoba'];
    _villages['Biryogo'] = ['Bidudu', 'Biryogo', 'Buhoro', 'Gihanama', 'Kagarama', 'Kanyonyomba', 'Rugunga']; // Example data, replace with actual data
    _villages['Kabuye'] = ['Bidudu', 'Kabuye', 'Karizinge', 'Rwagasiga', 'Rweteto']; // Example data, replace with actual data
    _villages['Kamatamu'] = ['Amajyambere', 'Bukinanyana', 'Cyimana', 'Gataba', 'Itetero', 'Kabare']; // Example data, replace with actual data
    _villages['Kamutwa'] = ['Agasaro', 'Gasharu', 'Inkingi', 'Kanserege', 'Kigugu', 'Ruganwa', 'Umuco']; // Example data, replace with actual data
    _villages['Bibare'] = ['Abatuje', 'Amariza', 'Imanzi', 'Imena', 'Imitari', 'Inganji']; // Example data, replace with actual data
    _villages['Kibagabaga'] = ['Akintwari', 'Buranga', 'Gasharu', 'Ibuhoro', 'Kageyo', 'Kamahinda', 'Karisimbi', 'Karongi', 'Nyirabwana', 'Ramiro', 'Rindiro', 'Rugero']; // Example data, replace with actual data
    _villages['Bungwe'] = ['Bungwe', 'Gakeri', 'Gatenga', 'Kinihira', 'Nyabyondo', 'Rweru']; // Example data, replace with actual data
    _villages['Cyiri'] = ['Curusi', 'Cyendajuru', 'Cyimpunga', 'Katiro', 'Kigitega', 'Kinyana']; // Example data, replace with actual data
    _villages['Burunga'] = ['Kabuga', 'Majuri', 'Matyazo', 'Nyabikenke', 'Nyamarebe', 'Ruyenzi']; // Example data, replace with actual data
   
  }

Future<void> _sendNotification() async {
  if (_formKey.currentState!.validate()) {
    final title = _titleController.text;
    final message = _messageController.text;

    try {
      Query query = FirebaseFirestore.instance.collection('users');

      if (_selectedTarget == 'Specific Location') {
        if (_selectedProvince != null) query = query.where('province', isEqualTo: _selectedProvince);
        if (_selectedDistrict != null) query = query.where('district', isEqualTo: _selectedDistrict);
        if (_selectedSector != null) query = query.where('sector', isEqualTo: _selectedSector);
        if (_selectedCell != null) query = query.where('cell', isEqualTo: _selectedCell);
        if (_selectedVillage != null) query = query.where('village', isEqualTo: _selectedVillage);
      }

      QuerySnapshot userSnapshot = await query.get();

      for (var doc in userSnapshot.docs) {
        await FirebaseFirestore.instance.collection('users').doc(doc.id).collection('notifications').add({
          'id': DateTime.now().millisecondsSinceEpoch, // Ensure 'id' is set
          'title': title,
          'body': message, // Correct key name from 'message' to 'body'
          'time': FieldValue.serverTimestamp(), // Ensure 'time' is set
          'type': 0, // Default type, adjust as needed
          'location': _selectedVillage ?? _selectedCell ?? _selectedSector ?? _selectedDistrict ?? _selectedProvince ?? 'Unknown',
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notification Sent Successfully'),
      ));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Notification Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _titleController,
                labelText: 'Title',
                icon: Icons.title,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _messageController,
                labelText: 'Message',
                icon: Icons.message,
                maxLines: 4,
              ),
              SizedBox(height: 10),
              _buildDropdownButton(
                value: _selectedTarget,
                hint: 'Select Target',
                items: _targets.map((String target) {
                  return DropdownMenuItem<String>(
                    value: target,
                    child: Text(target),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTarget = value as String?;
                  });
                },
              ),
              if (_selectedTarget == 'Specific Location') ...[
                SizedBox(height: 10),
                _buildDropdownButton(
                  value: _selectedProvince,
                  hint: 'Select Province',
                  items: _provinces.map((String province) {
                    return DropdownMenuItem<String>(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value as String?;
                      _selectedDistrict = null;
                      _selectedSector = null;
                      _selectedCell = null;
                      _selectedVillage = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                _buildDropdownButton(
                  value: _selectedDistrict,
                  hint: 'Select District',
                  items: _selectedProvince != null
                      ? _districts[_selectedProvince]!.map((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(district),
                          );
                        }).toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value as String?;
                      _selectedSector = null;
                      _selectedCell = null;
                      _selectedVillage = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                _buildDropdownButton(
                  value: _selectedSector,
                  hint: 'Select Sector',
                  items: _selectedDistrict != null
                      ? _sectors[_selectedDistrict]!.map((String sector) {
                          return DropdownMenuItem<String>(
                            value: sector,
                            child: Text(sector),
                          );
                        }).toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      _selectedSector = value as String?;
                      _selectedCell = null;
                      _selectedVillage = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                _buildDropdownButton(
                  value: _selectedCell,
                  hint: 'Select Cell',
                  items: _selectedSector != null
                      ? _cells[_selectedSector]!.map((String cell) {
                          return DropdownMenuItem<String>(
                            value: cell,
                            child: Text(cell),
                          );
                        }).toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      _selectedCell = value as String?;
                      _selectedVillage = null;
                    });
                  },
                ),
                SizedBox(height: 10),
                _buildDropdownButton(
                  value: _selectedVillage,
                  hint: 'Select Village',
                  items: _selectedCell != null
                      ? _villages[_selectedCell]!.map((String village) {
                          return DropdownMenuItem<String>(
                            value: village,
                            child: Text(village),
                          );
                        }).toList()
                      : [],
                  onChanged: (value) {
                    setState(() {
                      _selectedVillage = value as String?;
                    });
                  },
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendNotification,
                child: Text('Send Notification'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
    );
  }

  Widget _buildDropdownButton({
    String? value,
    required String hint,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
      isExpanded: true,
      items: items,
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Please select $hint';
        }
        return null;
      },
    );
  }
}
