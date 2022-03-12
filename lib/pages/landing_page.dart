import 'dart:async';

import 'package:dumpr/utils/constants.dart';
import 'package:dumpr/utils/dialogs.dart';
import 'package:dumpr/utils/navigate_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  startTimeout() {
    return Timer(const Duration(seconds: 2), handleTimeout);
  }

  void handleTimeout() {
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      requestPermission();
    } else {
      NavigateHelper.pushPageReplacement(context, const HomePage());
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      NavigateHelper.pushPageReplacement(context, const HomePage());
    } else {
      Dialogs.showToast('Please Grant Storage Permissions');
    }
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.folder,
              size: 70.0,
            ),
            const SizedBox(height: 20.0),
            Text(
              Constants.appName,
              style: const TextStyle(
                 fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
