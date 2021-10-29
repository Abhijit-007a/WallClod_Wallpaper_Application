import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingIndicatorHome extends StatelessWidget {
  final bool isLoading2;
  const LoadingIndicatorHome({Key key, @required this.isLoading2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: isLoading2 ? 70 : double.infinity,
        height: 90,
        child: isLoading2
            ?GlowingProgressIndicator(duration: Duration(milliseconds: 500),
            child: Image.asset('assets/appIcon/Loading.png'),
        )
            : Center(child: Text("Could not load Images")),
      ),
    );
  }
}
