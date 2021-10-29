import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:wall_clod/Providers/favImageProvider.dart';
import 'package:wall_clod/ScreensAndPages/FeaturedPage.dart';
import 'package:wall_clod/ScreensAndPages/SettingsPage.dart';
import 'package:wall_clod/ScreensAndPages/CollectionsPage.dart';
import 'package:wall_clod/ScreensAndPages/FavImagesPage.dart';
import 'package:wall_clod/ScreensAndPages/HomePage.dart';
import 'package:wall_clod/ScreensAndPages/SearchImagePage.dart';
import 'package:wall_clod/ScreensAndPages/TrendingWallpapersPage.dart';
import 'package:wall_clod/ScreensAndPages/PhotoEditor.dart';
import 'package:wall_clod/Widgets/Favourite.dart';
import 'package:wall_clod/Widgets/SettingsMenu.dart';
import 'Helpers''/Theme.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


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
    builder: (context, ThemeNotifier notifier, child)
    {
      return MaterialApp(
        title: 'WallClod',
        home: AnimatedSplashScreen(
          splash: Image.asset(
              'assets/images/Wallclod.png'
          ),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: Color(0xFF2b3f5c),
          splashIconSize: 500,
          duration: 100,
          centered: true,
          nextScreen: MyHomePage(),
        ),
        debugShowCheckedModeBanner: false,
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

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 7,
    child: Scaffold(
      backgroundColor: Color(0xFF272727),
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
        bottom: TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorPadding: EdgeInsets.only(left: 15,right: 15),
          unselectedLabelColor: Colors.white38,
          indicatorWeight: 3,
          tabs: [
            Tab(icon: Icon(Icons.wallpaper), text: 'New Arrivals'),
            Tab(icon: Icon(Icons.trending_up), text: 'Trending'),
            Tab(icon: Icon(Icons.collections), text: 'Collections'),
            Tab(icon: Icon(Icons.storage), text: 'Featured'),
            Tab(icon: Icon(Icons.edit), text: 'Photo Editor'),
            Tab(icon: Icon(Icons.favorite), text: 'Favourites'),
            Tab(icon: Icon(Icons.settings), text: 'Settings'),
          ],
        ),
        titleSpacing: 20,
      ),
      body: TabBarView(
        children: [
          buildPage(HomePage()),
          buildPage(TrendingWallpaperPage()),
          buildPage(AllCategoryScreen()),
          buildPage(FeaturedImagePage()),
          buildPage(PhotoEditor()),
          buildPage(FavouriteImagesPage()),
          buildPage(SettingsPage()),
        ],
      ),
    ),
  );


  buildPage(body) {
    return Center(
      child: body,
    );
  }

/*
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
        child: Icon(Icons.search_rounded, size: 20,),
        backgroundColor: Colors.red, elevation: 10,
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
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.wallpaper, color: Colors.blueGrey),
              title: Text(
                'New Arrival', style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.wallpaper, color: Colors.lightBlue),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.collections_rounded, color: Colors.blueGrey),
              title: Text(
                'Collections', style: TextStyle(color: Colors.white),),
              activeIcon: Icon(
                  Icons.collections_rounded, color: Colors.lightGreen),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.favorite, color: Colors.blueGrey),
              title: Text('Favourite', style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.favorite, color: Colors.redAccent),
            ),
            BubbleBottomBarItem(
              backgroundColor: Color(0xFF5379b1),
              icon: Icon(Icons.settings, color: Colors.blueGrey),
              title: Text('Settings', style: TextStyle(color: Colors.white),),
              activeIcon: Icon(Icons.settings, color: Colors.yellowAccent),
            ),
          ],
        ),
      ),
      body: (currentIndex == 0)
          ? HomePage()
          : (currentIndex == 1)
          ? AllCategoryScreen()
          : (currentIndex == 2)
          ? FavouriteImagesPage()
          : SettingsPage(),
    );
  }*/
}

