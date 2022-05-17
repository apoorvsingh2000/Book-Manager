import 'package:book_management/components/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var db = FirebaseFirestore.instance;
  String order = 'name';
  var myMenuItems = <String>[
    'Name',
    'Genre',
  ];
  void onSelect(item) {
    switch (item) {
      case 'Name':
        setState(() {
          order = 'name';
        });
        break;
      case 'Genre':
        setState(() {
          order = 'genre';
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Books"),
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: onSelect,
                itemBuilder: (BuildContext context) {
                  return myMenuItems.map((String choice) {
                    return PopupMenuItem<String>(
                      child: Text(choice),
                      value: choice,
                    );
                  }).toList();
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('books').orderBy(order).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent,
                ),
              );
            }
            final books = snapshot.data?.docs;
            List<BookItem> bookList = [];
            for (var book in books) {
              final name = book['name'];
              final genre = book['genre'];
              final imageUrl1 = book['imageUrl1'];
              final imageUrl2 = book['imageUrl2'];
              final des = book['des'];
              final author = book['author'];
              final BookItem item =
                  BookItem(name, genre, imageUrl1, imageUrl2, des, author);
              bookList.add(item);
            }
            return GridView(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: bookList,
            );
          },
        ),
      ),
    );
  }
}
