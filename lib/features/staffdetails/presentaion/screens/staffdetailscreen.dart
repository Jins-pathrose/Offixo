import 'package:flutter/material.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/provider/staffdetailsprovider.dart';
import 'package:offixoadmin/features/staffdetails/presentaion/widgets/staffdetailsview.dart';
import 'package:provider/provider.dart';

class StaffDetailsScreen extends StatelessWidget {
  final int staffId;
  const StaffDetailsScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context) {
    print('🟢 StaffDetailsScreen created with staffId: $staffId');
    
    return ChangeNotifierProvider(
      create: (_) {
        print('🟡 Creating StaffDetailsProvider with staffId: $staffId');
        return StaffDetailsProvider(staffId: staffId);
      },
      child: const StaffDetailsView(), // Now no parameter needed
    );
  }
}