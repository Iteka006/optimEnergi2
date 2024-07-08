import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _meterNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Location variables
  String? _selectedProvince;
  String? _selectedDistrict;
  String? _selectedSector;
  String? _selectedCell;
  String? _selectedVillage;
  final String _role = 'user';

  // Dropdown options
  List<String> _provinces = ['Kigali', 'East', 'North', 'West', 'South'];
  Map<String, List<String>> _districts = {};
  Map<String, List<String>> _sectors = {};
  Map<String, List<String>> _cells = {};
  Map<String, List<String>> _villages = {};

  // Function to update dropdown options
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

  @override
  void initState() {
    super.initState();
    _updateDropdownOptions();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final meterNumber = _meterNumberController.text;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final telephone = _telephoneController.text;
      final password = _passwordController.text;

      try {
        DocumentReference userRef = await FirebaseFirestore.instance.collection('users').add({
          'username': username,
          'meterNumber': meterNumber,
          'firstName': firstName,
          'lastName': lastName,
          'telephone': telephone,
          'password': password,
          'role': _role,
          'province': _selectedProvince,
          'district': _selectedDistrict,
          'sector': _selectedSector,
          'cell': _selectedCell,
          'village': _selectedVillage,
        });

        await userRef.collection('energy_usage').add({
          'date': Timestamp.now(),
          'usage': 0.0,
        });

        await userRef.collection('notifications').add({
          'title': 'Welcome',
          'body': 'Thank you for signing up!',
          'time': Timestamp.now(),
          'type': 1,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('User Added Successfully'),
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
      backgroundColor: Color.fromRGBO(244, 244, 244, 0.9),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.0, 80.0, 16.0, 0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Add a User',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _meterNumberController,
                labelText: 'Meter Number',
                icon: Icons.electric_meter,
                validator: _validateMeterNumber,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                icon: Icons.person,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                icon: Icons.person_outline,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _telephoneController,
                labelText: 'Telephone Number',
                icon: Icons.phone,
                validator: _validateTelephone,
              ),
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
              SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Add User'),
                ),
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
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.red),
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      obscureText: obscureText,
      validator: validator,
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
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.location_on, color: Colors.red),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String? _validateMeterNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your meter number';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid meter number';
    }
    return null;
  }

  String? _validateTelephone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your telephone number';
    }
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'Please enter a valid telephone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }
}
