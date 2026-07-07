import 'package:flutter/material.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/screens/createbranchview.dart';
import 'package:provider/provider.dart';

import 'package:offixoadmin/features/branch/data/model/branchmodel.dart';

class CreateBranchScreen extends StatelessWidget {
  final BranchModel? existing;
  const CreateBranchScreen({super.key, this.existing});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateBranchProvider()..init(existing),
      child: const CreateBranchView(),
    );
  }
}