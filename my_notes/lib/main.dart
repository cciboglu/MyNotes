import 'dart:io';
import 'package:flutter/services.dart';
import 'package:my_notes/main_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'note.dart';
import 'package:path/path.dart';

void main() {
  runApp(Start());
}

class Start extends StatelessWidget {
  
  Start({super.key});
  
  final Color darkgrey = const Color(0xff1b1b1b);
  final Color white = Colors.white;
  final Color blueGrey = Colors.blueGrey;
  final Color black = Colors.black;
  
  Future<List<Note>> contentGetter() async{
    String path = join(await getDatabasesPath(), 'database.db');
    File file = File(path);
    bool databaseExists = await file.exists();

    Database database = await openDatabase(path);
    List<Note> results = [];
    if(databaseExists){
      List notes = await database.rawQuery("SELECT * FROM notes");
      for(var i in notes){
        results.add(Note.fromMap(i));
      }
    }
    else{
      await database.execute("CREATE TABLE notes(id TEXT PRIMARY KEY, headline TEXT, content TEXT, lastEdit TEXT, created INTEGER)",);
    }
    return results;
  }

  Future<Widget> allWidget() async{
      List<Note> content = await contentGetter();
      return MainScreen(title: 'Main Page', content: content);
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNotes',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: darkgrey,
        primaryColor: white,
        appBarTheme: AppBarTheme(
          backgroundColor: white,
          foregroundColor: black,

          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: blueGrey,
            //systemNavigationBarColor: blueGrey,
          ),
          elevation: 122.0,
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),

        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(30.0))),
        ),
        inputDecorationTheme:  InputDecorationTheme(
          fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: black),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: black),
          ),
        ),
        
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.white
        ),
        iconTheme: IconThemeData(
          color: white
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: white
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(TextStyle(color: black)),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: white,
          foregroundColor: darkgrey
        ),

        textTheme: TextTheme(
          headline1: const TextStyle(
              color: Colors.black, fontSize: 17.0),
          headline2: TextStyle(
              color: black, fontSize: 17.0),
          headline3: TextStyle(
              color: black, fontSize: 17.0),
          headline4: TextStyle(
              color: black, fontSize: 17.0),
          headline5: TextStyle(
              color: black, fontSize: 17.0),
          headline6: TextStyle(
              color: black, fontSize: 17.0),
          subtitle1: TextStyle(
              color: black, fontSize: 17.0),
          subtitle2: TextStyle(
              color: black, fontSize: 17.0),
          bodyText1: TextStyle(
              color: black, fontSize: 17.0),
          bodyText2: TextStyle(
              color: black, fontSize: 17.0),
          caption: TextStyle(
              color: black, fontSize: 17.0),
          button: TextStyle(
              color: black, fontSize: 17.0),
          overline: TextStyle(
              color: black, fontSize: 17.0),
        ),
      ),
      home: FutureBuilder<Widget>(
        future: allWidget(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
           );
          default:
            if (snapshot.hasError) {
              return Column(
                children: const [
                  Text("Loading failed"),
                  Text("Please reload the App"),
                ],
              );
            } else {
              return (snapshot.data!);
            }
          }
        },
      ),
    );
  }
}


