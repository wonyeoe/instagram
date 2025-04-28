import 'package:flutter/material.dart';
import 'package:instagram/sytle.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
        home: MyApp()
      )
  );
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  addData(a){
    setState(() {
      data.add(a);
    });
  }

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  @override
  void initState() { //로드될 때 실행됨
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,
              MaterialPageRoute(builder: (c){ return Text('새페이지');})
            );
          }, icon: Icon(Icons.add_box_outlined), iconSize: 30,)
        ],
      ),
      body: [Home(data : data, addData : addData), Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샵')
        ],
      ),

    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key, this.data, this.addData});
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener((){ //scroll이 변할 때마다 실행
      if(scroll.position.pixels == scroll.position.maxScrollExtent){ //끝까지 내리면
        getMore();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if(widget.data.isNotEmpty){
      return ListView.builder(
          itemCount:widget.data.length,
          controller: scroll,
          itemBuilder: (c, i){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(widget.data[i]['image']),
                Text('좋아요${widget.data[i]['likes'].toString()}'),
                Text(widget.data[i]['user']),
                Text(widget.data[i]['content']),
              ],
            );
          }
      );
    }
    else{
      return Text('로딩중');
    }
  }
}
