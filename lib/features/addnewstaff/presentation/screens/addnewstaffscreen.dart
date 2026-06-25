import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addstaffprovider.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/appdropdown.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/datepickerfield.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/faceimagepicker.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/formfiled.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/savebutton.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/sectiontitle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/staffappbar.dart';
import 'package:provider/provider.dart';

class AddNewStaffScreen extends StatelessWidget {
  const AddNewStaffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddStaffProvider(),
      child: const _AddNewStaffView(),
    );
  }
}

class _AddNewStaffView extends StatelessWidget {
  const _AddNewStaffView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddStaffProvider>();
    final choices = provider.choices;

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      bottomNavigationBar: SaveButton(
        label: 'Continue',
        isLoading: provider.isLoading,
        onTap: () => context.read<AddStaffProvider>().submit(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── App Bar ──
              const StaffAppBar(),
              const SizedBox(height: 24),

              // ════════════════════════════════
              //  SECTION: Basic Details
              // ════════════════════════════════
              const SectionTitle(title: 'Basic Details'),
              const SizedBox(height: 14),

              // First Name + Last Name
              Row(
                children: [
                  Expanded(
                    child: FormFields(
                      label: 'First Name',
                      isRequired: true,
                      child: AppTextField(
                        hint: 'Eg: Jins',
                        onChanged: provider.setFirstName,
                        errorText: provider.errors['firstName'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FormFields(
                      label: 'Last Name',
                      isRequired: true,
                      child: AppTextField(
                        hint: 'Eg: Pathrose',
                        onChanged: provider.setLastName,
                        errorText: provider.errors['lastName'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Phone
              FormFields(
                label: 'Phone Number',
                isRequired: true,
                child: AppTextField(
                  hint: '+91 9074321123',
                  keyboardType: TextInputType.phone,
                  onChanged: provider.setPhoneNumber,
                  errorText: provider.errors['phoneNumber'],
                ),
              ),
              const SizedBox(height: 14),

              // Email
              FormFields(
                label: 'Email',
                isRequired: true,
                child: AppTextField(
                  hint: 'charlenereed@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: provider.setEmail,
                  errorText: provider.errors['email'],
                ),
              ),
              const SizedBox(height: 14),

              // Blood Group + Gender — Dropdowns from API
              Row(
                children: [
                  Expanded(
                    child: FormFields(
                      label: 'Blood Group',
                      isRequired: true,
                      child: AppDropdown(
                        hint: 'Select',
                        value: provider.bloodGroup.isEmpty
                            ? null
                            : provider.bloodGroup,
                        items: choices.bloodGroups
                            .map((e) => e.id)
                            .toList(),
                        itemLabels: {
                          for (final e in choices.bloodGroups)
                            e.id: e.name
                        },
                        onChanged: provider.setBloodGroup,
                        errorText: provider.errors['bloodGroup'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FormFields(
                      label: 'Gender',
                      isRequired: true,
                      child: AppDropdown(
                        hint: 'Select',
                        value: provider.gender.isEmpty
                            ? null
                            : provider.gender,
                        items:
                            choices.genders.map((e) => e.id).toList(),
                        itemLabels: {
                          for (final e in choices.genders) e.id: e.name
                        },
                        onChanged: provider.setGender,
                        errorText: provider.errors['gender'],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date of Birth
              FormFields(
                label: 'Date of Birth',
                isRequired: true,
                child: DatePickerField(
                  hint: '25 January 1990',
                  selectedDate: provider.dateOfBirth,
                  onDateSelected: provider.setDateOfBirth,
                  errorText: provider.errors['dateOfBirth'],
                ),
              ),
              const SizedBox(height: 14),

              // Present Address
              FormFields(
                label: 'Present Address',
                isRequired: true,
                child: AppTextField(
                  hint: 'Enter your address',
                  maxLines: 3,
                  onChanged: provider.setPresentAddress,
                  errorText: provider.errors['presentAddress'],
                ),
              ),
              const SizedBox(height: 28),

              // ════════════════════════════════
              //  SECTION: Work Details
              // ════════════════════════════════
              const SectionTitle(title: 'Work Details'),
              const SizedBox(height: 14),

              // Date of Joining
              FormFields(
                label: 'Date of Joining',
                isRequired: true,
                child: DatePickerField(
                  hint: '25 May 2025',
                  selectedDate: provider.dateOfJoining,
                  onDateSelected: provider.setDateOfJoining,
                  errorText: provider.errors['dateOfJoining'],
                ),
              ),
              const SizedBox(height: 14),

              // Branch — Dropdown from API
              FormFields(
                label: 'Branch',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Branch',
                  value: provider.branch.isEmpty ? null : provider.branch,
                  items: choices.branches.map((e) => e.id).toList(),
                  itemLabels: {
                    for (final e in choices.branches) e.id: e.name
                  },
                  onChanged: provider.setBranch,
                  errorText: provider.errors['branch'],
                ),
              ),
              const SizedBox(height: 14),

              // Department — Dropdown from API
              FormFields(
                label: 'Department',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Department',
                  value:
                      provider.department.isEmpty ? null : provider.department,
                  items: choices.departments.map((e) => e.id).toList(),
                  itemLabels: {
                    for (final e in choices.departments) e.id: e.name
                  },
                  onChanged: provider.setDepartment,
                  errorText: provider.errors['department'],
                ),
              ),
              const SizedBox(height: 14),

              // Designation — Dropdown from API (designations)
              FormFields(
                label: 'Designation',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Designation',
                  value: provider.designation.isEmpty
                      ? null
                      : provider.designation,
                  items: choices.designations.map((e) => e.id).toList(),
                  itemLabels: {
                    for (final e in choices.designations) e.id: e.name
                  },
                  onChanged: provider.setDesignation,
                  errorText: provider.errors['designation'],
                ),
              ),
              const SizedBox(height: 14),

              // Member Type — Dropdown from API (member_types)
              FormFields(
                label: 'Member Type',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Member Type',
                  value: provider.memberType.isEmpty
                      ? null
                      : provider.memberType,
                  items: choices.memberTypes.map((e) => e.id).toList(),
                  itemLabels: {
                    for (final e in choices.memberTypes) e.id: e.name
                  },
                  onChanged: provider.setMemberType,
                  errorText: provider.errors['memberType'],
                ),
              ),
              const SizedBox(height: 14),

              // Working Shift — Dropdown from API
              FormFields(
                label: 'Working Shift',
                isRequired: true,
                child: AppDropdown(
                  hint: 'Select Shift',
                  value: provider.workingShift.isEmpty
                      ? null
                      : provider.workingShift,
                  items: choices.shifts.map((e) => e.id).toList(),
                  itemLabels: {
                    for (final e in choices.shifts) e.id: e.name
                  },
                  onChanged: provider.setWorkingShift,
                  errorText: provider.errors['workingShift'],
                ),
              ),
              const SizedBox(height: 28),

              // ════════════════════════════════
              //  SECTION: Face Images
              // ════════════════════════════════
              const SectionTitle(title: 'Face Images'),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: FaceImagePicker(
                      label: 'Front Side',
                      isRequired: true,
                      scanLabel: 'Scan front side',
                      image: provider.frontImage,
                      onTap: () => context
                          .read<AddStaffProvider>()
                          .pickImage(FaceImageSlot.front, context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FaceImagePicker(
                      label: 'Right Side',
                      isRequired: true,
                      scanLabel: 'Scan Right side',
                      image: provider.rightImage,
                      onTap: () => context
                          .read<AddStaffProvider>()
                          .pickImage(FaceImageSlot.right, context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: FaceImagePicker(
                      label: 'Left Side',
                      isRequired: true,
                      scanLabel: 'Scan Left side',
                      image: provider.leftImage,
                      onTap: () => context
                          .read<AddStaffProvider>()
                          .pickImage(FaceImageSlot.left, context),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}