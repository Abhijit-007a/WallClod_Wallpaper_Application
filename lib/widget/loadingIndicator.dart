import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  const LoadingIndicator({Key key, @required this.isLoading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: isLoading ? 45 : double.infinity,
        height: 30,
        child: isLoading
            ?JumpingDotsProgressIndicator(fontSize: 30,color: Colors.red,)
            : Center(child: Text("No Image Found")),
      ),
    );
  }
}
