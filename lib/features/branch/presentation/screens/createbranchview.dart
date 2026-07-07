import 'package:flutter/material.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/widgets/appdropdown.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/screens/officelocationscreen.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/branchappbar.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/createbutton.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/fieldlabel.dart';
import 'package:offixoadmin/features/branch/presentation/widgets/locationfield.dart';
import 'package:provider/provider.dart';

class CreateBranchView extends StatefulWidget {
  const CreateBranchView({super.key});

  @override
  State<CreateBranchView> createState() => _CreateBranchViewState();
}

class _CreateBranchViewState extends State<CreateBranchView> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _radiusCtrl;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CreateBranchProvider>();
    _nameCtrl = TextEditingController(text: provider.branchName);
    _phoneCtrl = TextEditingController(text: provider.phone);
    _radiusCtrl = TextEditingController(text: provider.punchInRadius);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _radiusCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateBranchProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── App Bar ──
              BranchAppBar(isEdit: provider.isEdit),
              const SizedBox(height: 24),

              // ── Section Title ──
              Text(
                'Branch Details',
                style: AppStyle.text(
                  size: 16,
                  color: AppStyle.sectionColor,
                  weight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // ── Branch Name ──
              const FieldLabel(label: 'Branch Name', isRequired: true),
              const SizedBox(height: 6),
              AppTextField(
                controller: _nameCtrl,
                hint: 'Enter Branch name',
                onChanged: (v) => provider.branchName = v,
                errorText: provider.errors['branchName'],
              ),
              const SizedBox(height: 14),

              // ── Phone Number ──
              const FieldLabel(label: 'Phone Number', isRequired: true),
              const SizedBox(height: 6),
              AppTextField(
                controller: _phoneCtrl,
                hint: 'Enter Phone number',
                keyboardType: TextInputType.phone,
                onChanged: (v) => provider.phone = v,
                errorText: provider.errors['phone'],
              ),
              const SizedBox(height: 14),

              // ── Branch Location ──
              const FieldLabel(label: 'Branch Location', isRequired: true),
              const SizedBox(height: 6),
              LocationField(
                selectedLocation: provider.selectedLocation,
                errorText: provider.errors['location'],
                onTap: () async {
                  final result = await Navigator.push<SelectedLocation>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const OfficeLocationScreen(),
                    ),
                  );
                  if (result != null && context.mounted) {
                    context.read<CreateBranchProvider>().setLocation(result);
                  }
                },
              ),
              const SizedBox(height: 14),

              // ── Punch-in Radius ──
              const FieldLabel(
                  label: 'Punch-in Radius (Meters)', isRequired: true),
              const SizedBox(height: 6),
              AppTextField(
                controller: _radiusCtrl,
                hint: 'Choose Punch-in Radius',
                keyboardType: TextInputType.number,
                onChanged: (v) => provider.punchInRadius = v,
                errorText: provider.errors['punchInRadius'],
              ),

              const SizedBox(height: 24),

              // ── Create Branch Button ──
              CreateButton(
                isEdit: provider.isEdit,
                isLoading: provider.isLoading,
                onTap: () => provider.submit(context),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}