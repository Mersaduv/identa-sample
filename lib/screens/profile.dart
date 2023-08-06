import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:identa/classes/language_constants.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:intl/intl.dart' as intl;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedLocation;
  late NoteProvider noteProvider;
  // File? _coverImage;
  bool _status = true;
  @override
  void initState() {
    super.initState();
    noteProvider = context.read<NoteProvider>();
    _loadSavedData();
  }

  Future<void> _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    // if (result != null) {
    noteProvider.uploadProfilePicture(File(result!.files.single.path!));
    // setState(() {
    // _coverImage = File(result.files.single.path!);
    // _uploadProfilePicture();
    // });
    // }
  }

  Future<void> _loadSavedData() async {}

  Future<void> _saveData() async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = _emailController.text;
    String phoneNumber = _phoneController.text;
    String dateOfBirth = _selectedDate != null
        ? intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)
        : '';
    String zipCode = _zipController.text;
    String state = _stateController.text;
    String address = _addressController.text;
    String city = _cityController.text;
    String country = _selectedLocation ?? '';
    // var response = await ServiceApis.sendPostProfileRequest(
    //   firstName: firstName,
    //   lastName: lastName,
    //   email: email,
    //   phone: phoneNumber,
    //   address: address,
    //   city: city,
    //   state: state,
    //   zip: zipCode,
    //   country: countryCode,
    //   dateOfBirth: dateOfBirth,
    // );

    // if (response.statusCode == HttpStatus.ok) {
    //   print('Profile created successfully!');
    // } else {
    //   print('API request failed with status code ${response.statusCode}');
    // }
    var respond = await ServiceApis.sendGetProfileRequest();

    if (respond.statusCode == HttpStatus.ok) {
      var decodedResponse = jsonDecode(respond.body);
      print('Profile Data: $decodedResponse');
    } else {
      print('API request failed with status code ${respond.statusCode}');
    }

    setState(() {
      _status = true;
    });
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
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _coverImage = context.watch<NoteProvider>().coverImage;
    final ValueNotifier<TextDirection> _firstNameControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _lastNameControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _emailControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _phoneControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _addressControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _cityControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _stateControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _zipControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    final ValueNotifier<TextDirection> _countryControllerTextDir =
        ValueNotifier(TextDirection.ltr);
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveData();
            Navigator.of(context).pop();
          },
        ),
        title: translation(context).profile,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 142,
                height: 142,
                decoration: const BoxDecoration(
                  color: MyColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _coverImage != null
                        ? GestureDetector(
                            onTap: () {
                              if (_coverImage != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullScreenImageView(
                                        imagePath: context
                                            .read<NoteProvider>()
                                            .coverImage!
                                            .path),
                                  ),
                                );
                              }
                            },
                            child: ClipOval(
                              child: Image.file(
                                _coverImage!,
                                width: 142,
                                height: 142,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () {
                              _pickImageFromGallery();
                            },
                            color: Colors.white,
                            iconSize: 30,
                          ),
                    _coverImage != null
                        ? Positioned(
                            bottom: 2,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                                bottomRight: Radius.circular(100),
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                              ),
                              child: Opacity(
                                opacity: 0.4,
                                child: InkWell(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(100),
                                    bottomRight: Radius.circular(100),
                                    topLeft: Radius.zero,
                                    topRight: Radius.zero,
                                  ),
                                  onTap: () => _pickImageFromGallery(),
                                  child: Container(
                                    width: 142,
                                    height: 65,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2993CF),
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor:
                                              MyColors.primaryColor,
                                          radius: 16.0,
                                          child: Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                            size: 33,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Text(""),
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          translation(context).personalInformation,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _status ? _getEditIcon() : Container(),
                      ],
                    )
                  ],
                )),
            const SizedBox(height: 16),
            ValueListenableBuilder<TextDirection>(
              valueListenable: _firstNameControllerTextDir,
              builder: (context, value, child) => TextField(
                enabled: !_status,
                controller: _firstNameController,
                textDirection: _firstNameControllerTextDir.value,
                onChanged: (input) {
                  final isRTL = intl.Bidi.detectRtlDirectionality(input);
                  if (isRTL) {
                    _firstNameControllerTextDir.value = TextDirection.rtl;
                  } else {
                    _firstNameControllerTextDir.value = TextDirection.ltr;
                  }
                },
                decoration: InputDecoration(
                  labelText: translation(context).name,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<TextDirection>(
              valueListenable: _lastNameControllerTextDir,
              builder: (context, value, child) => TextField(
                enabled: !_status,
                controller: _lastNameController,
                textDirection: _lastNameControllerTextDir.value,
                onChanged: (input) {
                  final isRTL = intl.Bidi.detectRtlDirectionality(input);
                  if (isRTL) {
                    _lastNameControllerTextDir.value = TextDirection.rtl;
                  } else {
                    _lastNameControllerTextDir.value = TextDirection.ltr;
                  }
                },
                decoration: InputDecoration(
                  labelText: translation(context).lastName,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<TextDirection>(
              valueListenable: _emailControllerTextDir,
              builder: (context, value, child) => TextField(
                enabled: !_status,
                controller: _emailController,
                textDirection: _emailControllerTextDir.value,
                onChanged: (input) {
                  final isRTL = intl.Bidi.detectRtlDirectionality(input);
                  if (isRTL) {
                    _emailControllerTextDir.value = TextDirection.rtl;
                  } else {
                    _emailControllerTextDir.value = TextDirection.ltr;
                  }
                },
                decoration: InputDecoration(
                  labelText: translation(context).email,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<TextDirection>(
              valueListenable: _phoneControllerTextDir,
              builder: (context, value, child) => TextField(
                enabled: !_status,
                controller: _phoneController,
                textDirection: _phoneControllerTextDir.value,
                onChanged: (input) {
                  final isRTL = intl.Bidi.detectRtlDirectionality(input);
                  if (isRTL) {
                    _phoneControllerTextDir.value = TextDirection.rtl;
                  } else {
                    _phoneControllerTextDir.value = TextDirection.ltr;
                  }
                },
                decoration: InputDecoration(
                  labelText: translation(context).phoneNumber,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  enabled: !_status,
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? intl.DateFormat('yyyy-MM-dd').format(_selectedDate!)
                        : '',
                  ),
                  decoration: InputDecoration(
                    labelText: translation(context).dateOfBirth,
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<TextDirection>(
                        valueListenable: _zipControllerTextDir,
                        builder: (context, value, child) => TextField(
                          enabled: !_status,
                          controller: _zipController,
                          textDirection: _zipControllerTextDir.value,
                          onChanged: (input) {
                            final isRTL =
                                intl.Bidi.detectRtlDirectionality(input);
                            if (isRTL) {
                              _zipControllerTextDir.value = TextDirection.rtl;
                            } else {
                              _zipControllerTextDir.value = TextDirection.ltr;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: translation(context).zipCode,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<TextDirection>(
                        valueListenable: _stateControllerTextDir,
                        builder: (context, value, child) => TextField(
                          enabled: !_status,
                          controller: _stateController,
                          textDirection: _stateControllerTextDir.value,
                          onChanged: (input) {
                            final isRTL =
                                intl.Bidi.detectRtlDirectionality(input);
                            if (isRTL) {
                              _stateControllerTextDir.value = TextDirection.rtl;
                            } else {
                              _stateControllerTextDir.value = TextDirection.ltr;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: translation(context).state,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<TextDirection>(
                        valueListenable: _addressControllerTextDir,
                        builder: (context, value, child) => TextField(
                          enabled: !_status,
                          controller: _addressController,
                          textDirection: _addressControllerTextDir.value,
                          onChanged: (input) {
                            final isRTL =
                                intl.Bidi.detectRtlDirectionality(input);
                            if (isRTL) {
                              _addressControllerTextDir.value =
                                  TextDirection.rtl;
                            } else {
                              _addressControllerTextDir.value =
                                  TextDirection.ltr;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: translation(context).address,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 2,
                      child: ValueListenableBuilder<TextDirection>(
                        valueListenable: _cityControllerTextDir,
                        builder: (context, value, child) => TextField(
                          enabled: !_status,
                          controller: _cityController,
                          textDirection: _cityControllerTextDir.value,
                          onChanged: (input) {
                            final isRTL =
                                intl.Bidi.detectRtlDirectionality(input);
                            if (isRTL) {
                              _cityControllerTextDir.value = TextDirection.rtl;
                            } else {
                              _cityControllerTextDir.value = TextDirection.ltr;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: translation(context).city,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: CountryListPick(
                  onChanged: (CountryCode? countryCode) {
                    _selectLocation(countryCode);
                  },
                  initialSelection: _selectedLocation,
                  appBar: CustomAppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    title: translation(context).selectCountry,
                  ),
                  useUiOverlay: true,
                  theme: CountryTheme(
                    lastPickText: translation(context).selectCountry,
                    labelColor: MyColors.primaryColor,
                    searchText: translation(context).search,
                    searchHintText: translation(context).searchHint,
                    alphabetSelectedBackgroundColor: MyColors.primaryColor,
                    isShowFlag: true,
                    isShowTitle: true,
                    isShowCode: false,
                    isDownIcon: true,
                    showEnglishName: true,
                  ),
                  useSafeArea: true,
                ),
              ),
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
      floatingActionButton: !_status ? _getActionButtons() : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: MyColors.primaryColor,
        radius: 22.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 22.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                _saveData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                translation(context).save,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _status = true;
                  FocusScope.of(context).requestFocus(FocusNode());
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(
                translation(context).cancel,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imagePath;

  const FullScreenImageView({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: FileImage(File(imagePath)),
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 2,
    );
  }
}
