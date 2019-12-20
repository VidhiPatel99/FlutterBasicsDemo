import 'package:flutter/material.dart';
import 'package:flutter_demo/models/PhotosResponse.dart';
import 'package:flutter_demo/models/PostResponse.dart';
import 'package:flutter_demo/network/APICalls.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  var mPost = new List<Post>();
  Future<List<Post>> postFuture;
  Future<List<Photo>> photoFuture;

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
            child: displayPhotoList(),
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
//                return Text(snapshot.data.title);
          return ListView.builder(
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
                  margin:
                      new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
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
                                    fontWeight: FontWeight.w800, fontSize: 18),
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
//                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return CircularProgressIndicator();
      },
    );
  }

  FutureBuilder<List<Photo>> displayPhotoList() {
    return FutureBuilder<List<Photo>>(
      future: photoFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
//                return Text(snapshot.data.title);
          return ListView.builder(
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
                  margin:
                      new EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      children: <Widget>[
                        Container(
                            height: 50,
                            width: 50,
                            child: Image.network(snapshot.data[index].url)),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data[index].id.toString(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 18),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data[index].title,
                                textAlign: TextAlign.left,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
//                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text(snapshot.error);
        }

        return CircularProgressIndicator();
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
}
