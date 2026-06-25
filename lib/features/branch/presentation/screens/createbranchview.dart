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

class CreateBranchView extends StatelessWidget {
  const CreateBranchView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CreateBranchProvider>();

    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      // No bottomNavigationBar — button placed inline below the form
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // ── App Bar ──
              const BranchAppBar(),
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
              FieldLabel(label: 'Branch Name', isRequired: true),
              const SizedBox(height: 6),
              AppTextField(
                hint: 'Enter Branch name',
                onChanged: (v) =>
                    context.read<CreateBranchProvider>().branchName = v,
                errorText: provider.errors['branchName'],
              ),
              const SizedBox(height: 14),

              // ── Branch Location ──
              FieldLabel(label: 'Branch Location', isRequired: true),
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
              FieldLabel(
                  label: 'Punch-in Radius (Meters)', isRequired: true),
              const SizedBox(height: 6),
              AppTextField(
                hint: 'Choose Punch-in Radius',
                keyboardType: TextInputType.number,
                onChanged: (v) =>
                    context.read<CreateBranchProvider>().punchInRadius = v,
                errorText: provider.errors['punchInRadius'],
              ),

              const SizedBox(height: 24),

              // ── Create Branch Button — inline, right after the form ──
              CreateButton(
                isLoading: provider.isLoading,
                onTap: () =>
                    context.read<CreateBranchProvider>().submit(context),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}