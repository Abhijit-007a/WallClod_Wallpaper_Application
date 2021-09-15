import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:wall_clod/provider/favImageProvider.dart';
import 'package:wall_clod/screens/SettingsPage.dart';
import 'package:wall_clod/screens/allCategorys.dart';
import 'package:wall_clod/screens/favImagesPage.dart';
import 'package:wall_clod/screens/homePage.dart';
import 'package:wall_clod/screens/searchedImagePage.dart';

import 'helper/Theme.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MultiProvider(
            providers: [
              ChangeNotifierProvider<FavImageProvider>(
                  create: (context) => FavImageProvider()),
            ],
            child: ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),
    child: Consumer<ThemeNotifier>(
    builder: (context, ThemeNotifier notifier, child) {
      return MaterialApp(
        title: 'WallClod',
        home: AnimatedSplashScreen(
          splash: Image.asset(
              'assets/images/Wallclod.png'
          ),
          nextScreen: MyHomePage(),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: Color(0xFF2b3f5c),
          splashIconSize: 500,
          duration: 100,
          centered: true,
        ),
      );
    },
    ),
    ),
    ),
    );
  }
}


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int currentIndex;

  @override
  void initState(){
    super.initState();

    currentIndex =0;
  }

  changePage(int index){
    setState((){
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2b3f5c),
        centerTitle: true,
        elevation: 50.0,
        title: Text('WallClod', style: TextStyle(letterSpacing: 5,fontFamily: 'Pacifico'),),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Color(0xFF272727),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchedImagePage()),
            );
          },
        child: Icon(Icons.search_rounded,size: 20,),
        backgroundColor: Colors.red,elevation: 10,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: BubbleBottomBar(
          opacity: 0.15,
          iconSize: 20,
          elevation: 20,
          backgroundColor: Color(0xFF2b3f5c),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          currentIndex: currentIndex,
          hasInk: true,
          inkColor: Colors.black45,
          hasNotch: false,
          fabLocation: BubbleBottomBarFabLocation.end,
          onTap: changePage,
          items:<BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.wallpaper,color: Colors.blueGrey),
              title: Text('Wallpaper',style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.wallpaper,color: Colors.lightBlue),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.collections_rounded,color: Colors.blueGrey),
              title: Text('Collection',style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.collections_rounded,color: Colors.lightGreen),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.favorite,color: Colors.blueGrey),
              title: Text('Favourite',style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.favorite,color: Colors.redAccent),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.settings,color: Colors.blueGrey),
              title: Text('Settings',style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.settings,color: Colors.yellowAccent),
            ),
          ],
        ),
      ),
      body: (currentIndex ==0)
          ? HomePage()
          :(currentIndex ==1)
          ? AllCategoryScreen()
          :(currentIndex ==2)
          ? FavouriteImagesPage()
          :SettingsPage(),
    );
  }
}