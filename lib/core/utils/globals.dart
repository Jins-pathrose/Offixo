import 'package:flutter/material.dart';

/// A global key for the ScaffoldMessenger to show Snackbars from anywhere in the app
/// without needing a BuildContext.
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
