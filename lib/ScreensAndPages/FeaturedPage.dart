import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wall_clod/APINetworking/FirebaseAPI.dart';
import 'package:wall_clod/Models/FirebaseFile.dart';
import 'package:wall_clod/ScreensAndPages/FeaturedImageView.dart';
import 'package:wall_clod/Widgets/LoadingIndicatorHome.dart';

class FeaturedImagePage extends StatefulWidget {
  @override
  _FeaturedImagePageState createState() => _FeaturedImagePageState();
}

class _FeaturedImagePageState extends State<FeaturedImagePage> {
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('FeaturedImages_WallClod/');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color(0xFF272727),
    body: FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: LoadingIndicatorHome(
              isLoading2: true,
            ));
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              final files = snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wallpaper,color: Colors.red,),
                      SizedBox(width: 20,),
                      Text('Our Featured Wallpapers',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return buildFile(context, file);
                      },
                    itemCount: files.length,
                    staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1.5),
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 0.0,
                    ),
                  ),
                ],
              );
            }
        }
      },
    ),
  );

  Widget buildFile(BuildContext context, FirebaseFile file) => Padding(
    padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 10.0,bottom: 0.0),
    child: Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FeaturedImageView(file: file),
        )),
        child: Image.network(
          file.url,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
