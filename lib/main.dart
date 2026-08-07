import 'package:flutter/material.dart';
import 'package:offixoadmin/core/utils/globals.dart';
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
import 'package:offixoadmin/core/providers/update_provider.dart';
import 'package:offixoadmin/core/widgets/update_dialog.dart';
import 'package:offixoadmin/core/services/update_service.dart';
import 'package:offixoadmin/core/services/notification_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await dotenv.load(fileName: ".env");
  await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => UpdateProvider()),
        ChangeNotifierProvider(create: (_) => AddStaffProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => AddStaffProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => CreateBranchProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => MaintainerProfileProvider()),
        ChangeNotifierProvider(create: (_) => LeaveTypeProvider()),
        ChangeNotifierProvider(create: (_) => LeaveRequestProvider()),
        ChangeNotifierProvider(create: (_) => LeaveSettingsProvider()),
        ChangeNotifierProvider(create: (_) => DepartmentProvider()),
        ChangeNotifierProvider(create: (_) => AddSalaryProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => ShiftProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial check for updates after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UpdateProvider>().checkForUpdate();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Check for updates or resume immediate update when returning to foreground
      context.read<UpdateProvider>().checkForUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      builder: (context, child) {
        return Scaffold(
          body: Stack(
            children: [
              if (child != null) child,
              const Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: FlexibleUpdateRestartPrompt(),
              ),
              Consumer<UpdateProvider>(
                builder: (context, updateProvider, _) {
                  if (updateProvider.state == UpdateState.available) {
                    return Positioned.fill(
                      child: Container(
                        color: Colors.black54,
                        child: const Center(
                          child: UpdateDialog(
                            isImmediate:
                                UpdateService.defaultStrategy ==
                                UpdateStrategy.immediate,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
