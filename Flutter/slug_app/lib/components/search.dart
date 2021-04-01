// Trevor:
//   Most of this code was given and modified from the following YouTube
//   video: https://www.youtube.com/watch?v=H3CCtCmBUoQ

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/style.dart';
import 'dart:math';
import 'package:sandbox/theme/themes.dart';
import '../screens/profpages.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  CollectionReference profs =
      FirebaseFirestore.instance.collection('Fall2011_Perfect');
  List allResults = [];
  List resultsList = [];

  @override
  void initState() {
    super.initState();

    // generate list (QuerySnapshot) of the collection and add all of the
    // professors names to allResults list
    profs.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            allResults.add(doc.id); // add professor names to list
          })
        });

    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    List showResults = [];

    if (searchController.text != "") {
      for (var query in allResults) {
        var title = query.toLowerCase();
        if (title.contains(searchController.text.toLowerCase())) {
          showResults.add(query);
        }
      }
    }

    setState(() {
      resultsList = showResults;
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: Column(
        children: <Widget>[
          Text('', style: TextStyle(fontSize: 10),),  // spaceholder (new line)
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: ' Search'),
              showCursor: true,
              cursorColor: SlugThemes().accentThree,
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 60),
              itemCount: min(resultsList.length, 20),  // limit to only display <= 20 results
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return TextButton(
                    child: Text(
                      resultsList[index],
                      style: SlugThemes().searchTextTheme(),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ProfPage(
                                    Professor(
                                        resultsList[index], "Fall2011_Perfect"),
                                  )));
                    });
              },
            ),
          )
        ],
      ),
    );
  }
}
