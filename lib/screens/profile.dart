import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_list_pick/country_list_pick.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedLocation;
  late SharedPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _firstNameController.text = _preferences.getString('firstName') ?? '';
      _lastNameController.text = _preferences.getString('lastName') ?? '';
      final savedDate = _preferences.getString('dob');
      if (savedDate != null) {
        _selectedDate = DateFormat('yyyy-MM-dd').parse(savedDate);
      }
      _selectedLocation = _preferences.getString('location') ?? '';
    });
  }

  Future<void> _saveData() async {
    await _preferences.setString('firstName', _firstNameController.text);
    await _preferences.setString('lastName', _lastNameController.text);
    if (_selectedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      await _preferences.setString('dob', formattedDate);
    }
    await _preferences.setString('location', _selectedLocation ?? '');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectLocation(CountryCode? countryCode) {
    if (countryCode != null) {
      setState(() {
        _selectedLocation = countryCode.name;
      });
      _saveData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _saveData();
            Navigator.of(context).pop();
          },
        ),
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: const Color(0xFF2993CF),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Handle profile picture upload
                  },
                  color: Colors.white,
                  iconSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              onChanged: (value) {
                _saveData();
              },
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lastNameController,
              onChanged: (value) {
                _saveData();
              },
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : '',
                  ),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            CountryListPick(
              onChanged: (CountryCode? countryCode) {
                _selectLocation(countryCode);
              },
              initialSelection: _selectedLocation,
              theme: CountryTheme(
                isShowFlag: true,
                isShowTitle: true,
                isShowCode: false,
                isDownIcon: true,
                showEnglishName: true,
              ),
              useSafeArea: false,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _saveData();
    super.dispose();
  }
}
