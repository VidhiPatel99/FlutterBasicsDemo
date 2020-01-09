import 'package:flutter/material.dart';
import 'package:flutter_demo/models/PhotosResponse.dart';
import 'package:flutter_demo/models/PostResponse.dart';
import 'package:flutter_demo/network/APICalls.dart';
import 'package:flutter_demo/utils/constants/language_constants.dart';
import 'package:flutter_demo/utils/theme/text_form_field_theme.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  var mPost = new List<Post>();
  Future<List<Post>> postFuture;
  Future<List<Photo>> photoFuture;

  List<Photo> duplicatePhotoList = List();
  List<Photo> mainPhotoList = List();

  TextEditingController searchTextController = TextEditingController();

  bool isShowCloseButton = false;
  ItemScrollController _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    postFuture = APICalls.fetchPost();
    photoFuture = APICalls.fetchPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Column(children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                style: TextFromFieldTheme.textFieldTextStyle,
                decoration:
                    TextFromFieldTheme.textFieldInputDecoration.copyWith(
                  hintText: LanguageConstants.search,
                  suffixIcon: Visibility(
                    visible: isShowCloseButton,
                    child: GestureDetector(
                      child: Icon(
                        Icons.close,
                        color: Colors.black38,
                      ),
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        searchTextController.text = "";
                        filterSearchResult("");
                        _scrollController.scrollTo(
                            index: 0,
                            duration: Duration(seconds: 1));
                      },
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                ),
                keyboardType: TextInputType.text,
                controller: searchTextController,
                onChanged: (val) {
                  filterSearchResult(val);
                },
              ),
              SizedBox(
                height: 5,
              ),
              displayPhotoList()
            ]),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<Post>> displayPostList() {
    return FutureBuilder<List<Post>>(
      future: postFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Dismissible(
                  key: Key(snapshot.data[index].id.toString()),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    setState(() {
                      snapshot.data.removeAt(index);
                    });

                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('${snapshot.data[index].id} item deleted'),
                    ));
                  },
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    margin: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            snapshot.data[index].id.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  snapshot.data[index].title,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data[index].body,
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder<List<Photo>> displayPhotoList() {
    return FutureBuilder<List<Photo>>(
      future: photoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          duplicatePhotoList.addAll(snapshot.data);
          mainPhotoList.addAll(snapshot.data);

          return Expanded(
            child: Scrollbar(
              child: ScrollablePositionedList.builder(
                itemScrollController: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return Dismissible(
                    key: Key(mainPhotoList[index].id.toString()),
                    background: Container(color: Colors.red),
                    direction: DismissDirection.horizontal,
                    onDismissed: (direction) {
                      setState(() {
                        mainPhotoList.removeAt(index);
                      });

                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:
                            Text('${mainPhotoList[index].id} item deleted'),
                      ));
                    },
                    child: Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      margin: new EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Container(
                                height: 50,
                                width: 50,
                                child: Image.network(mainPhotoList[index].url)),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    mainPhotoList[index].id.toString(),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    mainPhotoList[index].title,
                                    textAlign: TextAlign.left,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  makeListItem(AsyncSnapshot<List<Post>> snapshot, int index) {
    Card(
      elevation: 5.0,
      child: Container(
        decoration: BoxDecoration(color: Colors.blueGrey),
        child: getListTile(snapshot, index),
      ),
    );
  }

  ListTile getListTile(AsyncSnapshot<List<Post>> snapshot, int index) {
    return ListTile(
      leading: Text(
        snapshot.data[index].id.toString(),
        style: TextStyle(color: Colors.black),
      ),
      title: Text(
        snapshot.data[index].title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(snapshot.data[index].body),
      contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
    );
  }

  filterSearchResult(String searchText) {
    List<Photo> searchMatchList = List();

    if (searchText.isNotEmpty) {
      duplicatePhotoList.forEach((item) {
        if (item.title.contains(searchText)) {
          searchMatchList.add(item);
        }
      });

      setState(() {
        isShowCloseButton = true;
        mainPhotoList.clear();
        mainPhotoList.addAll(searchMatchList);
      });

      return;
    } else {
      setState(() {
        isShowCloseButton = false;
        mainPhotoList.clear();
        mainPhotoList.addAll(duplicatePhotoList);
      });
    }
  }
}
