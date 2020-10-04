import 'package:flutter/material.dart';
import './fragments/picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "AniMe",
        home: Scaffold(
          appBar: AppBar(
            title: Text("AniMe"),
          ),
          body: HomePage(),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () => print("Camera Tapped"),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.camera_alt), Text("Use Camera")],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  print("Photo Tapped");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Picker()),
                  );
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.camera_alt), Text("Use Photo")],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
