import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(
        channel: new IOWebSocketChannel.connect("ws://echo.websocket.org"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final WebSocketChannel channel;
  MyHomePage({@required this.channel});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController t=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Web Socket"),
      ),
      body: new Padding(padding: const EdgeInsets.all(20.0),
       child: new Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           new Form(
               child: new TextFormField(
                 decoration: new InputDecoration(labelText: "Send any message"),
                 controller: t,
               )
           ),
           new StreamBuilder(
             stream: widget.channel.stream,
             builder: (context,snapshot){
               return new Padding(padding: const EdgeInsets.all(20.0),
               child: new Text(snapshot.hasData? '${snapshot.data}' : ''),

               );
             },
           )
         ],
       ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.send),
        onPressed: _sendMyMessage,
      ),
    );
  }

  void _sendMyMessage(){
    if(t.text.isNotEmpty){
      widget.channel.sink.add(t.text);

    }
  }

   @override
  void dispose() {
    // TODO: implement dispose
    widget.channel.sink.close();
    super.dispose();

  }
}




