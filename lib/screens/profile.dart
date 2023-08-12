import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:identa/widgets/loading/profile/cardSkeleton.dart';
import 'package:identa/classes/language_constants.dart';
import 'package:identa/constants/colors.dart';
import 'package:identa/core/models/model_core/profile_data%20.dart';
import 'package:identa/core/repositories/note_provider.dart';
import 'package:identa/widgets/profile/profile_image_widget.dart';
import 'package:identa/services/apis/api.dart';
import 'package:identa/widgets/app_bar_content.dart';
import 'package:identa/widgets/loading/skeleton.dart';
import 'package:intl/intl.dart' as intl;
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic>? profileData;
  ProfilePage(this.profileData, {Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

const double defaultPadding = 16.0;

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
  bool _status = true;
  bool _showLoading = false;

  @override
  void initState() {
    super.initState();
    noteProvider = context.read<NoteProvider>();
    noteProvider.getProfileData();
    _firstNameController.text = widget.profileData?['firstName'] ?? "";
    _lastNameController.text = widget.profileData?['lastName'] ?? "";
    _emailController.text = widget.profileData?['email'] ?? "";
    _phoneController.text = widget.profileData?['phone'] ?? "";
    _addressController.text = widget.profileData?['address'] ?? "";
    _cityController.text = widget.profileData?['city'] ?? "";
    _stateController.text = widget.profileData?['state'] ?? "";
    _zipController.text = widget.profileData?['zip'] ?? "";
    _selectedLocation = widget.profileData?['country'] ?? "";
    if (widget.profileData?["dateOfBirth"] != null) {
      _selectedDate = intl.DateFormat('yyyy-MM-dd')
          .parse(widget.profileData?["dateOfBirth"]);
    } else {
      _selectedDate = DateTime.now();
    }

    // _loadSavedData();
  }

  Future<void> _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    noteProvider.setCoverImage(null);

    await noteProvider.uploadProfilePicture(File(result!.files.single.path!));
    noteProvider.downloadProfilePicture();
    // _loadSavedData();
  }

  // Future<void> _loadSavedData() async {
  //   Map<String, dynamic>? profileData = widget.profileData;

  //   if (profileData != null) {
  //     _firstNameController.text = profileData['firstName'];
  //     _lastNameController.text = profileData['lastName'];
  //     _emailController.text = profileData['email'];
  //     _phoneController.text = profileData['phoneNumber'];
  //     _addressController.text = profileData['address'];
  //     _cityController.text = profileData['city'];
  //     _stateController.text = profileData['state'];
  //     _zipController.text = profileData['zipCode'];
  //     _countryController.text = profileData['country'];
  //   }
  //   noteProvider.downloadProfilePicture();
  // }

  Future<void> _saveData() async {
    noteProvider.profileData?.clear();
    String formattedDate =
        intl.DateFormat('yyyy-MM-ddTHH:mm:ss.SSSSSSSZ').format(_selectedDate!);
    ProfileData profileData = ProfileData(
        firstName: _firstNameController.text.isNotEmpty
            ? _firstNameController.text
            : null,
        lastName: _lastNameController.text.isNotEmpty
            ? _lastNameController.text
            : null,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        address:
            _addressController.text.isNotEmpty ? _addressController.text : null,
        city: _cityController.text.isNotEmpty ? _cityController.text : null,
        state: _stateController.text.isNotEmpty ? _stateController.text : null,
        zip: _zipController.text.isNotEmpty ? _zipController.text : null,
        country: _selectedLocation!.isNotEmpty ? _selectedLocation : null,
        dateOfBirth: formattedDate.isNotEmpty ? null : null);
    await ServiceApis.sendPostProfileRequest(profileData);
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
        _selectedLocation = countryCode.code;
      });
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
    noteProvider.getProfileData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provide = context.watch<NoteProvider>();
    var _coverImage = provide.coverImage;
    var _profileData = provide.profileData;
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
    return Consumer<NoteProvider>(
      builder: (context, value, child) {
        if (_profileData == null) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Skeleton(height: 90, width: 90),
                    const SizedBox(height: 60),
                    Expanded(
                      child: ListView.separated(
                        itemCount: 6,
                        itemBuilder: (context, index) =>
                            const CardSkeltonProfile(),
                        separatorBuilder: (context, index) => const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: SizedBox(height: defaultPadding),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: CustomAppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () async {
                noteProvider.profileDataIsNull();
                await noteProvider.getProfileData();
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
                ProfileImageWidget(
                  coverImage: _coverImage,
                  onPickImage: _pickImageFromGallery,
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
                            ? intl.DateFormat('yyyy-MM-dd')
                                .format(_selectedDate!)
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
                                  _zipControllerTextDir.value =
                                      TextDirection.rtl;
                                } else {
                                  _zipControllerTextDir.value =
                                      TextDirection.ltr;
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
                                  _stateControllerTextDir.value =
                                      TextDirection.rtl;
                                } else {
                                  _stateControllerTextDir.value =
                                      TextDirection.ltr;
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
                                  _cityControllerTextDir.value =
                                      TextDirection.rtl;
                                } else {
                                  _cityControllerTextDir.value =
                                      TextDirection.ltr;
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
                    child: AbsorbPointer(
                      absorbing: _status,
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
                          alphabetSelectedBackgroundColor:
                              MyColors.primaryColor,
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
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
          floatingActionButton: !_status ? _getActionButtons() : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
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
              onPressed: () async {
                try {
                  setState(() {
                    _showLoading = true;
                  });
                } catch (e) {
                  print(e.toString());
                } finally {
                  await _saveData();
                  setState(() {
                    _status = true;
                    _showLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: _showLoading
                  ? const SizedBox(
                      width: 11,
                      height: 11,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
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
