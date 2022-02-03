import 'package:flutter/material.dart';
import 'package:my_tool_box/databases/ImageDB.dart';
import 'package:my_tool_box/languageChangeProvider.dart';
import 'package:my_tool_box/models/ImageModel.dart';
import 'details.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<ImageModel> images = [];
StreamController<List<ImageModel>> streamController =
    StreamController.broadcast();

void getImages() async {
  Future<List<ImageModel>> temp = ImageDB.instance.getImages();
  images = await temp;
  streamController.add(images);
  debugPrint(images.length.toString());
}

class Gallery extends StatefulWidget {
  _galleryState createState() => _galleryState();
}

class _galleryState extends State<Gallery> {
  final ImagePicker _picker = ImagePicker();

  void initState() {
    super.initState();
    getImages();
  }

  void addToGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      String imagePath = await image.path;
      ImageDB.instance.create(imagePath);
      debugPrint(imagePath);
      getImages();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.gallery,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {
                      addToGallery();
                    },
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      color: Colors.white,
                    ),
                    tooltip: AppLocalizations.of(context)!.add_view,
                  ),
                ]),
            SizedBox(
              height: 40,
            ),
            StreamBuilder<List<ImageModel>>(
                stream: streamController.stream,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      debugPrint("waiting");
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.none:
                      debugPrint("none");
                      return Center(child: CircularProgressIndicator());
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 30,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return RawMaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsPage(
                                        imagePath: images[index].path,
                                        title: basename(images[index].path),
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: 'logo$index',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                            FileImage(File(images[index].path)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: images.length,
                          ),
                        ),
                      );
                      break;
                  }
                })
          ],
        ),
      ),
    );
  }
}

class ImageDetails {
  final String imagePath;
  final String title;
  ImageDetails({required this.imagePath, required this.title});
}
