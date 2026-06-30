import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';

class EditTab extends StatefulWidget {
  final StaffDetailsProvider provider;

  const EditTab({Key? key, required this.provider}) : super(key: key);

  @override
  State<EditTab> createState() => _EditTabState();
}

class _EditTabState extends State<EditTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final details = widget.provider.staffDetails;
    _firstNameController = TextEditingController(text: details?.firstName ?? '');
    _lastNameController = TextEditingController(text: details?.lastName ?? '');
    _emailController = TextEditingController(text: details?.email ?? '');
    _phoneController = TextEditingController(text: details?.phoneNumber ?? '');
    _dobController = TextEditingController(text: details?.dateOfBirth ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;
    if (_dobController.text.isNotEmpty) {
      try {
        initialDate = DateTime.parse(_dobController.text);
      } catch (e) {
        initialDate = DateTime.now();
      }
    } else {
      initialDate = DateTime.now();
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _updateStaff() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone_number': _phoneController.text.trim(),
        'date_of_birth': _dobController.text.trim(),
      };

      try {
        await widget.provider.updateStaff(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Staff details updated successfully.')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update: $e')),
          );
        }
      }
    }
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isEmail = false, bool isPhone = false, bool isDate = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : (isPhone ? TextInputType.phone : TextInputType.text),
        readOnly: isDate,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppStyle.text(size: 13, color: AppStyle.hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppStyle.accentCyan, width: 2),
          ),
          suffixIcon: isDate ? const Icon(Icons.calendar_today, color: AppStyle.hintColor, size: 20) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_outlined, color: AppStyle.accentCyan, size: 20),
                const SizedBox(width: 8),
                Text('Edit Staff Profile', style: AppStyle.text(size: 15, weight: FontWeight.w700)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(child: _buildTextField('First Name', _firstNameController)),
                const SizedBox(width: 12),
                Expanded(child: _buildTextField('Last Name', _lastNameController)),
              ],
            ),
            _buildTextField('Email', _emailController, isEmail: true),
            _buildTextField('Phone Number', _phoneController, isPhone: true),
            _buildTextField(
              'Date of Birth',
              _dobController,
              isDate: true,
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.provider.isLoading ? null : _updateStaff,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.accentCyan,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 0,
                ),
                child: widget.provider.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text('Update Details', style: AppStyle.text(size: 14, weight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}