import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wall_clod/Responsiveness/enums/device_screen_type.dart';
import 'package:wall_clod/Responsiveness/utils/ui_utils.dart';

import 'CustomNotificationOnPage.dart';

class InAppNotification {
  imageDownloaded(
      BuildContext context, IconData iconData, Color color, String message) {
    var mediaQuery = MediaQuery.of(context);
    DeviceScreenType deviceScreenType = getDeviceType(mediaQuery);
    return showOverlayNotification(
      (context) {
        return CustomNotificationOnPage(
          icon: iconData,
          iconColor: color,
          subTitle: message,
        );
      },
      duration: Duration(milliseconds: 3000),
      position: deviceScreenType == DeviceScreenType.Desktop
          ? NotificationPosition.bottom
          : NotificationPosition.top,
    );
  }

  imageDownloadFailed(BuildContext context, IconData iconData, String message) {
    var mediaQuery = MediaQuery.of(context);
    DeviceScreenType deviceScreenType = getDeviceType(mediaQuery);
    showOverlayNotification(
      (context) {
        return CustomNotificationOnPage(
            icon: iconData, iconColor: Colors.black, subTitle: message);
      },
      duration: Duration(milliseconds: 3000),
      position: deviceScreenType == DeviceScreenType.Desktop
          ? NotificationPosition.bottom
          : NotificationPosition.top,
    );
  }
}
