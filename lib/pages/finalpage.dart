import 'package:ecommerce/pages/home.dart';
import 'package:flutter/material.dart';

class FinalPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 150, 0, 0),
                      child: Text(
                        "Happy",
                        style: TextStyle(
                            fontSize: 88,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 240, 0, 0),
                      child: Text(
                        "Shopping",
                        style: TextStyle(
                            fontSize: 88,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Text();
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                  child: MaterialButton(
                height: 60,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                color: Colors.red,
                child: Text(
                  "Shop More ?",
                  style: TextStyle(fontSize: 21),
                ),
                textColor: Colors.white,
              ))
            ],
          ),
        ));
  }
}
