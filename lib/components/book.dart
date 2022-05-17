import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:image_picker/image_picker.dart';

class BookItem extends StatefulWidget {
  final _name;
  final _genre;
  final _imageUrl1;
  final _imageUrl2;
  final _des;
  final _author;

  BookItem(this._name, this._genre, this._imageUrl1, this._imageUrl2, this._des,
      this._author);

  @override
  State<BookItem> createState() => _BookItemState();
}

class _BookItemState extends State<BookItem> {
  final picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();
  File pickedImage;
  var db = FirebaseFirestore.instance;
  var imageUrl;

  Future getImage() async {
    String name = widget._name.toString();
    final image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedImage = File(image.path);
    });
    await storageRef.child(name).putFile(pickedImage);
    imageUrl = await storageRef.child(name).getDownloadURL();
    setState(() {
      imageUrl = imageUrl;
    });
    setImageUrl();
  }

  Future setImageUrl() async {
    String name = widget._name.toString();
    await db.collection('books').doc(name).update(
      {
        'imageUrl1': imageUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await getImage();
                Navigator.pop(context);
              },
              child: const Icon(Icons.image),
            ),
            body: Container(
              margin: EdgeInsets.only(
                  left: screenWidth(context) * 0.05,
                  right: screenWidth(context) * 0.05,
                  top: screenWidth(context) * 0.1,
                  bottom: screenWidth(context) * 0.3),
              child: Column(
                children: [
                  Expanded(
                    child: PinchZoom(
                      child: Image.network(widget._imageUrl1),
                    ),
                  ),
                  SizedBox(
                    height: screenWidth(context) * 0.05,
                  ),
                  Text(widget._des),
                  SizedBox(
                    height: screenWidth(context) * 0.05,
                  ),
                  Text(
                    widget._author,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: screenWidth(context) * 0.2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Card(
        elevation: 5.0,
        color: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.network(
                widget._imageUrl1,
              ),
            ),
            Text(
              widget._name + '\n' + widget._genre,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
