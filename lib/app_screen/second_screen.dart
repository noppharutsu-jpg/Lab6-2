import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import './third_screen.dart';
  
class SecondScreen extends StatefulWidget {
    static const routeName = '/second'; // กำหนดชื่อให้ route
 
    @override
    State<StatefulWidget> createState() {
        return _SecondScreen();
    }
}
  
class _SecondScreen extends State<SecondScreen> {
    var _favorite = <WordPair>[];
 
    @override
    Widget build(BuildContext context) {
       _favorite = ModalRoute.of(context)!.settings.arguments as List<WordPair>;
 
        return Scaffold(
            appBar: AppBar(
                title: Text('Second Screen'),
                backgroundColor: Colors.green,
            ),
            body: Container(
                child: ListView.builder(
                    itemCount: _favorite.length,
                    itemBuilder: (context, index) {
                            return _buildRow(context, _favorite, index);
                    },
                ),
            ),
        );
    }
 
    Widget _buildRow(context, favoriteWord, index) {
        bool _alreadyFavorite = _favorite.contains(favoriteWord[index]);
        return Container(
            child: Column(
                children: <Widget>[
                    ListTile(
                        title: Text('${favoriteWord[index].asPascalCase}'),
                        trailing: Icon(
                            _alreadyFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _alreadyFavorite ? Colors.red : null,
                        ),
                        onTap: () {
                            _showYourChoice(context, favoriteWord[index]);
                        },
                    ),
                    const Divider(),
                ],
            ),
        );
    }    
 
    _showYourChoice(context, arg) async{ 
    // กำหนดรูปแบบข้อมูลเป็นแบบ Map
        Map<String, dynamic> args = {
          "msg": arg.asPascalCase.toString()
        };   
 
        // เมื่อเปิดหน้าใหม่ ให้รอผลลัพธ์สุดท้าย ถ้ามีการปิดหน้าที่เปิด      
        final result = await Navigator.pushNamed(
            context,
            ThirdScreen.routeName,
            arguments: args
        );
  
        // จัดการเงื่อนไขรับค่าที่ส่งกลับมา
        setState(() {
            if (result == 'Nope.') {
                _favorite.remove(arg);
            } else {
                _favorite.add(arg);
            }
        });
 
        // ส่วนสำหรับแสดงข้อความด้านล่างขอบหน้าจอ
        ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("$result")));
    }      
}