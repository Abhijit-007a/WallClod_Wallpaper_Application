import 'package:flutter/widgets.dart';
import 'package:wall_clod/Responsiveness/enums/device_screen_type.dart';
import 'dart:io';

DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
  double deviceWidth = mediaQuery.size.shortestSide;

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    return DeviceScreenType.Desktop;
  }

  if (deviceWidth > 500) {
    return DeviceScreenType.Tablet;
  }

  return DeviceScreenType.Mobile;
}
