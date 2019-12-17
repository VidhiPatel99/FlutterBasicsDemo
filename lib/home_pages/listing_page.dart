import 'package:flutter/material.dart';
import 'package:flutter_demo/models/PostResponse.dart';
import 'package:flutter_demo/network/GetPosts.dart';

class ListingPage extends StatefulWidget {
  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  var mPost = new List<Post>();
  Future<List<Post>> postFuture;

//  _getPost() {
//    APIcalls.fetchPost().then((response) {
//      setState(() {
//        Iterable list = json.decode(response.body);
//        mPost = list.map((model) => Post.fromJson(model)).toList();
//      });
//    });
//  }

  @override
  void initState() {
    super.initState();
//    _getPost();
    postFuture = APIcalls.fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black26,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
//            child: ListView.builder(
//                itemCount: mPost.length,
//                itemBuilder: (context, index) {
//                  return ListTile(title: Text(mPost[index].title));
//                }),
            child: FutureBuilder<List<Post>>(
              future: postFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
//                return Text(snapshot.data.title);
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Container(
                          padding: EdgeInsets.all(10.0),
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
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 16),
                                    ),
//                              Text(snapshot.data[index].body,
//                                  maxLines: 3, textAlign: TextAlign.left)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
//                      child: ListTile(
//                        leading: Text(snapshot.data[index].id.toString()),
//                        title: Text(snapshot.data[index].title),
//                        subtitle: Text(snapshot.data[index].body)
//                      ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text(snapshot.error);
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
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
