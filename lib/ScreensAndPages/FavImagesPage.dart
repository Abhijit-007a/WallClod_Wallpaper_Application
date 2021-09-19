import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wall_clod/database/dataBaseHelper/database_helper.dart';
import 'package:wall_clod/database/data_modal/favImage.dart';
import 'package:wall_clod/Providers/favImageProvider.dart';
import 'package:wall_clod/Widgets/AppNetWorkImage.dart';
import '../Helpers/favImagesFunctionPage.dart';
import 'FavImageView.dart';

class FavouriteImagesPage extends StatefulWidget {
  @override
  _FavouriteImagesPageState createState() => _FavouriteImagesPageState();
}

class _FavouriteImagesPageState extends State<FavouriteImagesPage> {
  List items = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      items = FavImages().getFavImages();
    });
  }

  showAlertDialog(BuildContext context, FavImage favImage, favImageProvider) {
    Widget okButton = ElevatedButton(
      child: Text("YES"),
      onPressed: () {
        removeFormFav(favImage, favImageProvider);
        Navigator.of(context).pop();
      },
    );
    Widget noButton = TextButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Remove?"),
      content: Text("Remove form your Favourites."),
      actions: [
        noButton,
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  removeFormFav(FavImage favImage, favImageProvider) async {
    final dbHelper = FavImageDatabaseHelper.instance;
    final hasData = await dbHelper.hasData(favImage.imageid.toString());
    if (hasData) {
      favImageProvider.removeFavImage(favImage.imageid.toString());
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavImageProvider>(
        builder: (context, favImageProvider, child) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 20.0,bottom: 20.0),
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(16.0),
                color: Colors.indigo,
              ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'LongPress on wallpaper you want to remove from Favourites!',
                      style: TextStyle(color:Colors.white60, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
          ),
          (favImageProvider.favImageList.length == 0)
              ? Expanded(child: Image.asset('assets/images/Favourites.png'),)
              : Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.6,
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: favImageProvider.favImageList.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index) {
                        FavImage favImage =
                            favImageProvider.favImageList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FavImageView(
                                  favImage: favImage,
                                ),
                              ),
                            );
                          },
                          child: GestureDetector(
                            onLongPress: () {
                              showAlertDialog(
                                  context, favImage, favImageProvider);
                            },
                            child: AppNetWorkImage(
                              imageUrl: favImage.small,
                              blurHash: favImage.blurHash,
                              height: 2,
                              width: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      );
    });
  }
}
