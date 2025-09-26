import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import './second_screen.dart';
import './third_screen.dart';
  
// ส่วนของ Stateful widget
class FirstScreen extends StatefulWidget{
    const FirstScreen({super.key});
 
    @override
    State<StatefulWidget> createState() {
        return _FirstScreen();
    }
}
class _FirstScreen extends State<FirstScreen>{
    var _randomWord = <WordPair>[];
    var _favorite = <WordPair>[]; // ส่วนที่เพิ่มมาใหม่ **
    final _biggerFont = const TextStyle(color: Colors.black,  fontSize: 20.0);
   
    void _addRandomWord(){
        setState(() {
            _randomWord.addAll(generateWordPairs().take(3));
        });
    }
   
    void _clearRandomWord(){
        setState(() {
            _randomWord.clear();
        });
    }
   
    void _loadRamdomWord(){
        setState(() {
            _randomWord.addAll(generateWordPairs().take(15));
            });
    }
   
    Future<void> _loadMoreRandomWord() {
        return Future.delayed(Duration(milliseconds: 10), () {
            setState(() {
                _randomWord.addAll(generateWordPairs().take(20));
            });
        });
    }
   
    @override
    Widget build(BuildContext context) {
        if (_randomWord.isEmpty){
            _loadRamdomWord();
        }
        return Scaffold(
            appBar: AppBar(
                title: Text('Welcome to Flutter'),
                backgroundColor: Colors.green,
                actions: <Widget>[
                    IconButton(
                        icon: const Icon(Icons.clear_all),
                        tooltip: 'Clear List',
                        onPressed: _clearRandomWord,
                    ),
                    IconButton(
                        icon: const Icon(Icons.favorite),
                        tooltip: 'Favorite List',
                        onPressed: () {
                          // ปรับส่วนของการส่งไปหน้าที่สอง
                          Navigator.pushNamed(
                              context,
                              SecondScreen.routeName,
                              arguments: _favorite
                          );                                  
                        }
                    ),
                ],
            ),
            body: Container(
                child: ListView.builder(
                        itemCount: _randomWord.length,
                        itemBuilder: (context, index) {
                            if (index == _randomWord.length -1){
                                _loadMoreRandomWord();
                            }
                            // เพิ่ม context
                            return _buildRow(context,_randomWord, index);
                        },
                ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: _addRandomWord,
                child: Icon(Icons.add),
            ),
        );
    }
   
    // เพิ่ม context เป็น paramter
    Widget _buildRow(context, randomWord, index) {
        bool _alreadyFavorite = _favorite.contains(randomWord[index]);
        return Container(
            child: Column(
                children: <Widget>[
                    ListTile(
                        title: Text('${randomWord[index].asPascalCase}'),
                        trailing: Icon(
                            _alreadyFavorite ? Icons.favorite : Icons.favorite_border,
                            color: _alreadyFavorite ? Colors.red : null,
                        ),                        
                        onTap: (){                       
                          _showYourChoice(context, randomWord[index]);
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