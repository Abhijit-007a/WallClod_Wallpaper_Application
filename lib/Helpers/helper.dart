
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wall_clod/Responsiveness/utils/ui_utils.dart';
import 'dart:math';
import 'dart:convert';
import '../Responsiveness/enums/device_screen_type.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class Helper {
  getMobileOrientation(context) {
    int cellCount = 4;
    var mediaQuery = MediaQuery.of(context);
    double deviceWidth = mediaQuery.size.shortestSide;
    print(deviceWidth);
    DeviceScreenType deviceScreenType = getDeviceType(mediaQuery);
    var orientation = mediaQuery.orientation;
    if (deviceScreenType == DeviceScreenType.Mobile) {
      cellCount = orientation == Orientation.portrait ? 4 : 8;
    } else if (deviceScreenType == DeviceScreenType.Tablet) {
      cellCount = 8;
    } else if (deviceScreenType == DeviceScreenType.Desktop) {
      cellCount = responsiveNumGridTiles(mediaQuery);
    }
    return cellCount;
  }

  int responsiveNumGridTiles(MediaQueryData mediaQuery) {
    double deviceWidth = mediaQuery.size.width;
    if (deviceWidth < 700) {
      return 6;
    } else if (deviceWidth < 1200) {
      return 10;
    } else if (deviceWidth < 1650) {
      return 18;
    } else {
      return 18;
    }
  }
//* OG Code to Test
//   int responsiveNumGridTiles(MediaQueryData mediaQuery) {
//   double deviceWidth = mediaQuery.size.width;
//   if (deviceWidth < 700) {
//     return 1;
//   } else if (deviceWidth < 1200) {
//     return 2;
//   } else if (deviceWidth < 1650) {
//     return 3;
//   }
//   return 4;
// }

  getPlatformType(context) {
    var mediaQuery = MediaQuery.of(context);
    DeviceScreenType deviceScreenType = getDeviceType(mediaQuery);
    return deviceScreenType;
  }

  dismissKeyBoard(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  isTablet(BuildContext context) {
    bool isTablet = false;
    var mediaQuery = MediaQuery.of(context);
    DeviceScreenType deviceScreenType = getDeviceType(mediaQuery);

    if (deviceScreenType == DeviceScreenType.Mobile) {
      isTablet = false;
    } else if (deviceScreenType == DeviceScreenType.Tablet) {
      isTablet = true;
    }
    return isTablet;
  }

  saveResponse(String key, String data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
    print(prefs);

    return true;
  }

  getSavedResponse(String key) async {
    String stringValue;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    stringValue = prefs.getString(key);
    return stringValue;
  }

  Future<bool> hasConnection() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      return true;
    } else {
      print(DataConnectionChecker().lastTryResults);
      return false;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  giveRandom() {
    var rng = new Random();
    for (var i = 0; i < 2; i++) {
      return rng.nextInt(10);
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    // ignore: deprecated_member_use
    return double.parse(s, (e) => null) != null;
  }

  String getFileName(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values) + ".png";
  }

  Future<String> getFilePath() async {
    final PathProviderPlatform provider = PathProviderPlatform.instance;
    try {
      return await provider.getDownloadsPath();
    } catch (exception) {
      return null;
    }
  }
}
