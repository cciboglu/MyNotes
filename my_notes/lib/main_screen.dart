import 'package:flutter/material.dart';
import 'package:my_notes/view_screen.dart';
import 'package:uuid/uuid.dart';
import 'note.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title, required this.content});

  final String title;
  final List<Note> content;

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  String appName = "MyNotes";
  String appMotto = "Your thougts. Your notes";
  String appVersion = "1.0.0";
  
  String getshorten(String content){
    if(content.length > 10){
      return content.substring(0, 10);
    }
    else{
      return content;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [
      const SizedBox(height: 30),
    ];
    for(var i in widget.content){
      cards.add(Dismissible(
          key: ValueKey<Note>(i),
          confirmDismiss: (DismissDirection a) async {
            return true;
          },
          onDismissed: (DismissDirection direction) async {
            Note.removeNote(i, widget.content);
          },
          direction: DismissDirection.endToStart,
          child: Card(
              child: OutlinedButton(
                onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute( 
                    builder: (context,) => ViewScreen(title: "", selectedContent: i,)))
                    .then(
                      (value) => setState(() {}));
                },
                  child: Center(
                      child: ListTile(
                          title: Text(getshorten(i.headline),),
                          subtitle: Text(getshorten(i.content)
                          )
                      )
                  )
              )
          )
      ));
    }

    return Scaffold(
      appBar: AppBar(
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.info), 
          onPressed: () => showAboutDialog(
            context: context,
            applicationName: appName,
            applicationVersion: appVersion,
            applicationLegalese: appMotto,
            children: [const Text("This app was created by Caner Ciboglu")],
          ),
        ),
      ],
        title: Text(widget.title),
      ),
      body: Center(
        child: cards.length > 1? ListView(
          children: cards,
        ): const Card(
          child: SizedBox(
            height: 70, 
            child: Center(
              child: Text("No note found. You can create one by clicking the +")
            )
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          Note note = Note(const Uuid().v4(), "", "", DateTime.now(), DateTime.now());
          Note.createNote(note, widget.content);
          Navigator.push(
            context,  
            MaterialPageRoute(
              builder: (context, ) => ViewScreen(
                        title: "",
                        selectedContent: note,
                      )
                    )
                  ).then(
                    (value) => setState(() {})
                  );
        },
        tooltip: 'Create',
        child: const Icon(Icons.add),
      ),
    );
  }
}
