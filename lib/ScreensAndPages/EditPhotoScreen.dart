import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_editor/image_editor.dart';
import 'package:wall_clod/ScreensAndPages/EditResultScreen.dart';

class EditPhotoScreen extends StatefulWidget {

  final List arguments;
  EditPhotoScreen({this.arguments});

  @override
  _EditPhotoScreenState createState() => _EditPhotoScreenState();
}

class _EditPhotoScreenState extends State<EditPhotoScreen> {

  final GlobalKey<ExtendedImageEditorState> editorKey =
  GlobalKey<ExtendedImageEditorState>();

  double sat = 1;
  double bright = 0;
  double con = 1;

  final defaultColorMatrix = const <double>[
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    1,
    0
  ];
  List<double> calculateSaturationMatrix(double saturation) {
    final m = List<double>.from(defaultColorMatrix);
    final invSat = 1 - saturation;
    final R = 0.213 * invSat;
    final G = 0.715 * invSat;
    final B = 0.072 * invSat;

    m[0] = R + saturation;
    m[1] = G;
    m[2] = B;
    m[5] = R;
    m[6] = G + saturation;
    m[7] = B;
    m[10] = R;
    m[11] = G;
    m[12] = B + saturation;

    return m;
  }

  List<double> calculateContrastMatrix(double contrast) {
    final m = List<double>.from(defaultColorMatrix);
    m[0] = contrast;
    m[6] = contrast;
    m[12] = contrast;
    return m;
  }

  File image;
  @override
  void initState() {
    super.initState();
    image = widget.arguments[0];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272727),
      appBar: AppBar(
        backgroundColor: Color(0xFF2b3f5c),
          title: Text(
            "Edit Image",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings_backup_restore),
              onPressed: () {
                setState(() {
                  sat = 1;
                  bright = 0;
                  con = 1;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                await crop();
              },
            ),
          ]),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              Container(
                child: buildImage(),
              ),
              Container(
                child: SliderTheme(
                  data: const SliderThemeData(
                    thumbColor: Colors.orangeAccent,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7),
                    activeTrackColor: Colors.yellowAccent,
                    showValueIndicator: ShowValueIndicator.never,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Color(0xFF272727),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildSat(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        _buildBrightness(),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        _buildCon(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    bottomNavigationBar: ClipRRect(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: BottomNavigationBar(
      backgroundColor:Color(0xFF2b3f5c),
      type: BottomNavigationBarType.fixed,
      elevation: 20,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_left,
            color: Colors.white,
          ),
            label: ''
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.flip,
            color: Colors.white,
          ),
            label: ''
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.rotate_right,
            color: Colors.white,
          ),
          label: ''
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            rotate(false);
            break;
          case 1:
            flip();
            break;
          case 2:
            rotate(true);
            break;
        }
      },
    ),
    ),
  );
}

  Widget buildImage() {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(calculateContrastMatrix(con)),
      child: ColorFiltered(
        colorFilter: ColorFilter.matrix(calculateSaturationMatrix(sat)),
        child: ExtendedImage(
          color: bright > 0
              ? Colors.white.withOpacity(bright)
              : Colors.black.withOpacity(-bright),
          colorBlendMode: bright > 0 ? BlendMode.lighten : BlendMode.darken,
          image: ExtendedFileImageProvider(image,cacheRawData: true),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          extendedImageEditorKey: editorKey,
          mode: ExtendedImageMode.editor,
          fit: BoxFit.contain,
          initEditorConfigHandler: (ExtendedImageState state) {
            return EditorConfig(
              maxScale: 8.0,
              cropRectPadding: const EdgeInsets.all(20.0),
              hitTestSize: 20.0,
            );
          },
        ),
      ),
    );
  }

  Future<void> crop([bool test = false]) async {
    final ExtendedImageEditorState state = editorKey.currentState;
    final Rect rect = state.getCropRect();
    final EditActionDetails action = state.editAction;
    final double radian = action.rotateAngle;

    final bool flipHorizontal = action.flipY;
    final bool flipVertical = action.flipX;
    final Uint8List img = state.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    option.addOption(ClipOption.fromRect(rect));
    option.addOption(
        FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
    if (action.hasRotateAngle) {
      option.addOption(RotateOption(radian.toInt()));
    }

    option.addOption(ColorOption.saturation(sat));
    option.addOption(ColorOption.brightness(bright + 1));
    option.addOption(ColorOption.contrast(con));

    option.outputFormat = const OutputFormat.jpeg(100);

    print(const JsonEncoder.withIndent('  ').convert(option.toJson()));

    final DateTime start = DateTime.now();
    final Uint8List result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    print('result.length = ${result.length}');

    final Duration diff = DateTime.now().difference(start);
    image.writeAsBytesSync(result);
    print('image_editor time : $diff');
    Future.delayed(Duration(seconds: 0)).then(
          (value) => Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => SaveImageScreen(
              arguments: [image],
            )),
      ),
    );
  }

  void flip() {
    editorKey.currentState.flip();
  }

  void rotate(bool right) {
    editorKey.currentState.rotate(right: right);
  }

  Widget _buildSat() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
        Column(
          children: <Widget>[
            Icon(
              Icons.colorize,
              color: Colors.white,
              size: 20,
            ),
            Text("Saturation",style: TextStyle(color: Colors.white),)
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.027,),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'sat : ${sat.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                sat = value;
              });
            },
            divisions: 50,
            value: sat,
            min: 0,
            max: 2,
          ),
        ),
        Padding(
          padding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(sat.toStringAsFixed(2),style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Widget _buildBrightness() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
        Column(
          children: <Widget>[
            Icon(
              Icons.brightness_6,
              color: Colors.white,
              size: 20,
            ),
            Text("Brightness",style: TextStyle(color: Colors.white),)
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.027,),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: '${bright.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                bright = value;
              });
            },
            divisions: 50,
            value: bright,
            min: -1,
            max: 1,
          ),
        ),
        Padding(
          padding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(bright.toStringAsFixed(2),style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  Widget _buildCon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(width: MediaQuery.of(context).size.width * 0.055,),
        Column(
          children: <Widget>[
            Icon(
              Icons.color_lens,
              color: Colors.white,
              size: 20,
            ),
            Text("Contrast",style: TextStyle(color: Colors.white),)
          ],
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.047,),
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Slider(
            label: 'con : ${con.toStringAsFixed(2)}',
            onChanged: (double value) {
              setState(() {
                con = value;
              });
            },
            divisions: 50,
            value: con,
            min: 0,
            max: 4,
          ),
        ),
        Padding(
          padding:
          EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.08),
          child: Text(con.toStringAsFixed(2),style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }
}
