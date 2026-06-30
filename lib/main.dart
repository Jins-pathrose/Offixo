import 'package:flutter/material.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addsalary.dart';
import 'package:offixoadmin/features/addnewstaff/presentation/provider/addstaffprovider.dart';
import 'package:offixoadmin/features/branch/presentation/provider/branchprovider.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';
import 'package:offixoadmin/features/checkincheckouts/presentation/provider/checkincheckoutprovider.dart';
import 'package:offixoadmin/features/department/presentation/provider/departmentprovider.dart';
import 'package:offixoadmin/features/home/presentation/provider/homeprovider.dart';
import 'package:offixoadmin/features/leave/presentation/provider/leaverequestprovider.dart';
import 'package:offixoadmin/features/leavetype/presentation/provider/leavesettingsprovider.dart';
import 'package:offixoadmin/features/leavetype/presentation/provider/leavetypeprovider.dart';
import 'package:offixoadmin/features/login/presentation/provider/logincontroller.dart';
import 'package:offixoadmin/features/settings/presentation/provider/maintainerprofileprovider.dart';
import 'package:offixoadmin/features/shift/presentation/provider/shiftprovider.dart';
import 'package:offixoadmin/features/splashscreen/presentation/screens/splashscreen.dart';
import 'package:offixoadmin/features/staffs/presentation/controller/staffprovider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AddStaffProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => AddStaffProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider(),),
        ChangeNotifierProvider(create: (_)=> CreateBranchProvider()),
        ChangeNotifierProvider(create: (_)=> HomeProvider()),
        ChangeNotifierProvider(create: (_)=> MaintainerProfileProvider()),
        ChangeNotifierProvider(create: (_)=> LeaveTypeProvider()),
        ChangeNotifierProvider(create: (_)=> LeaveRequestProvider()),
        ChangeNotifierProvider(create: (_)=> LeaveSettingsProvider()),
        ChangeNotifierProvider(create: (_)=> DepartmentProvider()),
        ChangeNotifierProvider(create: (_)=> AddSalaryProvider()),
        ChangeNotifierProvider(create: (_)=> AttendanceProvider()),
        ChangeNotifierProvider(create: (_)=> ShiftProvider()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
