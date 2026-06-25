import 'package:flutter/material.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/screens/createbranchview.dart';
import 'package:provider/provider.dart';

class CreateBranchScreen extends StatelessWidget {
  const CreateBranchScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateBranchProvider(),
      child: const CreateBranchView(),
    );
  }
}