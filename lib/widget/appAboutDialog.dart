import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AppAboutDialog {
  showAppAboutDialog(context) {
    showAboutDialog(
        context: context,
        applicationName: 'WallClod',
        applicationVersion: 'by Aesthetic Developers v1.0',
        applicationLegalese: 'All images are provided by unsplash.com',
        children: [
        ]);
  }
}
