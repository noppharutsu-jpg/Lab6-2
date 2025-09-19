import 'package:flutter/material.dart';
 
// ส่วนของ Stateful widget
class FirstScreen extends StatefulWidget{
    @override
    State<StatefulWidget> createState() {
        return _FirstScreen();
    }
}
class _FirstScreen extends State<FirstScreen>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Welcome to Flutter'),
                backgroundColor: Colors.green
            ),
            body: Material(
                color: Colors.lightGreen,
                child: Center(
                    child: Text(
                        'Hello World',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0
                        )
                    )
                )
            )
        );
    }
}