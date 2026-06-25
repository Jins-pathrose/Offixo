import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:offixoadmin/core/services/storagedevice.dart';
import 'package:offixoadmin/features/addnewstaff/data/addstaffreposnse.dart';
import 'package:offixoadmin/features/addnewstaff/domain/dorpdownmodel.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/screens/addsalaryscreen.dart';

// ─────────────────────────────────────────────
// ENUM
// ─────────────────────────────────────────────
enum FaceImageSlot { front, right, left }
enum DropdownLoadState { idle, loading, loaded, error }

// ─────────────────────────────────────────────
// ADD STAFF PROVIDER
// ─────────────────────────────────────────────
class AddStaffProvider extends ChangeNotifier {
  static const String _baseUrl =
      'https://offixo.archanastones.in/api/member/create/';
  static const String _dropdownUrl =
      'https://offixo.archanastones.in/api/member/dropdown-choices/';

  // ── Basic Details ──
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String email = '';
  String bloodGroup = '';
  String gender = '';
  DateTime? dateOfBirth;
  String presentAddress = '';

  // ── Work Details ──
  DateTime? dateOfJoining;
  String branch = '';        // stores branch ID
  String department = '';    // stores department ID
  String designation = '';   // stores designation ID
  String memberType = '';    // stores member_type code (FULL_TIME, etc.)
  String workingShift = '';

  // ── Face Images ──
  File? frontImage;
  File? rightImage;
  File? leftImage;

  // ── State ──
  bool isLoading = false;
  Map<String, String?> errors = {};
  AddStaffResponse? lastResponse;

  // ── Dropdown Choices ──
  DropdownLoadState dropdownState = DropdownLoadState.idle;
  DropdownChoices choices = DropdownChoices.empty();

  final StorageService _storageService = StorageService();

  AddStaffProvider() {
    fetchDropdownChoices();
  }

  // ─────────────────────────────────────────
  // Fetch Dropdown Choices
  // ─────────────────────────────────────────
  Future<void> fetchDropdownChoices() async {
    dropdownState = DropdownLoadState.loading;
    notifyListeners();
    try {
      final token = await _storageService.getAccessToken();
      final res = await http.get(
        Uri.parse(_dropdownUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        final json = jsonDecode(res.body) as Map<String, dynamic>;
        choices = DropdownChoices.fromJson(json);
        dropdownState = DropdownLoadState.loaded;
      } else {
        dropdownState = DropdownLoadState.error;
      }
    } catch (e) {
      debugPrint('Dropdown fetch error: $e');
      dropdownState = DropdownLoadState.error;
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // Setters — all call notifyListeners()
  // ─────────────────────────────────────────
  void setFirstName(String v) {
    firstName = v;
    notifyListeners();
  }

  void setLastName(String v) {
    lastName = v;
    notifyListeners();
  }

  void setPhoneNumber(String v) {
    phoneNumber = v;
    notifyListeners();
  }

  void setEmail(String v) {
    email = v;
    notifyListeners();
  }

  void setBloodGroup(String? v) {
    bloodGroup = v ?? '';
    notifyListeners();
  }

  void setGender(String? v) {
    gender = v ?? '';
    notifyListeners();
  }

  void setDateOfBirth(DateTime d) {
    dateOfBirth = d;
    notifyListeners();
  }

  void setPresentAddress(String v) {
    presentAddress = v;
    notifyListeners();
  }

  void setDateOfJoining(DateTime d) {
    dateOfJoining = d;
    notifyListeners();
  }

  void setBranch(String? v) {
    branch = v ?? '';
    notifyListeners();
  }

  void setDepartment(String? v) {
    department = v ?? '';
    notifyListeners();
  }

  void setDesignation(String? v) {
    designation = v ?? '';
    notifyListeners();
  }

  void setMemberType(String? v) {
    memberType = v ?? '';
    notifyListeners();
  }

  void setWorkingShift(String? v) {
    workingShift = v ?? '';
    notifyListeners();
  }

  // ─────────────────────────────────────────
  // Image Picker — Camera OR Gallery
  // ─────────────────────────────────────────
  Future<void> pickImage(FaceImageSlot slot, BuildContext context) async {
    final source = await _showImageSourceDialog(context);
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (picked == null) return;

    final file = File(picked.path);

    switch (slot) {
      case FaceImageSlot.front:
        frontImage = file;
        break;
      case FaceImageSlot.right:
        rightImage = file;
        break;
      case FaceImageSlot.left:
        leftImage = file;
        break;
    }

    notifyListeners();
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Select Image Source',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE0F7FA),
                  child: Icon(Icons.camera_alt_outlined,
                      color: Color(0xFF00ACC1)),
                ),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(Icons.photo_library_outlined,
                      color: Color(0xFF43A047)),
                ),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────
  // Validation
  // ─────────────────────────────────────────
  bool _validate() {
    errors = {};

    if (firstName.trim().isEmpty) errors['firstName'] = 'Required';
    if (lastName.trim().isEmpty) errors['lastName'] = 'Required';

    if (phoneNumber.trim().isEmpty) {
      errors['phoneNumber'] = 'Required';
    } else if (phoneNumber.trim().length < 10) {
      errors['phoneNumber'] = 'Enter valid phone number';
    }

    if (email.trim().isEmpty) {
      errors['email'] = 'Required';
    } else if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$').hasMatch(email.trim())) {
      errors['email'] = 'Enter valid email';
    }

    if (bloodGroup.trim().isEmpty) errors['bloodGroup'] = 'Required';
    if (gender.trim().isEmpty) errors['gender'] = 'Required';
    if (dateOfBirth == null) errors['dateOfBirth'] = 'Required';
    if (presentAddress.trim().isEmpty) errors['presentAddress'] = 'Required';
    if (dateOfJoining == null) errors['dateOfJoining'] = 'Required';
    if (branch.trim().isEmpty) errors['branch'] = 'Required';
    if (department.trim().isEmpty) errors['department'] = 'Required';
    if (designation.trim().isEmpty) errors['designation'] = 'Required';
    if (memberType.trim().isEmpty) errors['memberType'] = 'Required';
    if (workingShift.trim().isEmpty) errors['workingShift'] = 'Required';
    if (frontImage == null) errors['frontImage'] = 'Required';
    if (rightImage == null) errors['rightImage'] = 'Required';
    if (leftImage == null) errors['leftImage'] = 'Required';

    notifyListeners();
    return errors.isEmpty;
  }

  // ─────────────────────────────────────────
  // Submit Staff (Step 1) — Continue → Salary Screen
  // ─────────────────────────────────────────
  Future<void> submit(BuildContext context) async {
    if (!_validate()) return;

    isLoading = true;
    notifyListeners();

    try {
      final accessToken = await _storageService.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        _showSnack(context, 'Please try again later', isError: true);
        return;
      }

      final request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      request.headers.addAll({
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      });

      request.fields.addAll({
        'first_name': firstName.trim(),
        'last_name': lastName.trim(),
        'phone_number': phoneNumber.trim(),
        'email': email.trim(),
        'blood_group': bloodGroup.trim(),
        'gender': gender.trim(),
        'date_of_birth': _formatDate(dateOfBirth!),
        'present_address': presentAddress.trim(),
        'start_date': _formatDate(dateOfJoining!),
        'branch_id': branch.trim(),
        'department_id': department.trim(),
        'designation_id': designation.trim(),
        'member_type': memberType.trim(),
        'shift_id': workingShift.trim(),
      });

      if (frontImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'face_image_1', frontImage!.path));
      }
      if (rightImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'face_image_2', rightImage!.path));
      }
      if (leftImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'face_image_3', leftImage!.path));
      }

      debugPrint('Authorization: Bearer $accessToken');
      debugPrint('Fields: ${request.fields}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      Map<String, dynamic>? jsonResponse;
      try {
        jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        lastResponse = AddStaffResponse.fromJson(jsonResponse);
      } catch (_) {
        jsonResponse = null;
        lastResponse = null;
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          lastResponse?.success == true) {
        final member = lastResponse?.member;

        if (member == null) {
          _showSnack(context, 'Staff created but member id missing',
              isError: true);
          return;
        }

        if (context.mounted) {
          // Navigate to salary creation screen — do not pop yet.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddSalaryScreen(member: member),
            ),
          );
        }
      } else {
        // Try to extract field-level validation errors
        final fieldErrors = _parseFieldErrors(jsonResponse);

        if (fieldErrors.isNotEmpty) {
          errors.addAll(fieldErrors);
          final firstMessage =
              fieldErrors.values.first ?? 'Please try again later';
          _showSnack(context, firstMessage, isError: true);
          notifyListeners();
        } else {
          _showSnack(context, 'Please try again later', isError: true);
        }
      }
    } on SocketException {
      _showSnack(context, 'Please try again later', isError: true);
    } catch (e) {
      debugPrint('Add Staff Error: $e');
      _showSnack(context, 'Please try again later', isError: true);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────
  // Parse field-level API validation errors
  // ─────────────────────────────────────────
  Map<String, String?> _parseFieldErrors(Map<String, dynamic>? json) {
    if (json == null) return {};

    const fieldKeyMap = {
      'first_name': 'firstName',
      'last_name': 'lastName',
      'phone_number': 'phoneNumber',
      'email': 'email',
      'blood_group': 'bloodGroup',
      'gender': 'gender',
      'date_of_birth': 'dateOfBirth',
      'present_address': 'presentAddress',
      'start_date': 'dateOfJoining',
      'branch_id': 'branch',
      'department_id': 'department',
      'designation_id': 'designation',
      'member_type': 'memberType',
      'shift_id': 'workingShift',
      'face_image_1': 'frontImage',
      'face_image_2': 'rightImage',
      'face_image_3': 'leftImage',
    };

    final result = <String, String?>{};

    json.forEach((apiKey, value) {
      final mappedKey = fieldKeyMap[apiKey];
      if (mappedKey == null) return;

      String? message;
      if (value is List && value.isNotEmpty) {
        message = value.first.toString();
      } else if (value is String) {
        message = value;
      }

      if (message != null) {
        result[mappedKey] = message;
      }
    });

    return result;
  }

  // ─────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showSnack(BuildContext context, String message,
      {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? const Color(0xFFE53935) : const Color(0xFF22C55E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}