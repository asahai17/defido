import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange)),
    home: MyApp(),
  )
  );
}
class MyApp extends StatefulWidget {
  //const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*List todo = [];*/
  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  String todoTitle = "";
  getTodoTitle(title) {
    this.todoTitle = title;
  }
  createTodo() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodo").doc(todoTitle);
    Map<String, String> todos = {
      "todoTitle": todoTitle
    };
    documentReference.set(todos).whenComplete((){
      print("$todoTitle created");
    });
  }
  deleteToDo(item){

    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodo").doc(item);
    documentReference.delete().whenComplete((){
      print("$todoTitle deleted");
    });

  }

  /*@override
  void initState() {
    super.initState();
    todo.add("Item1");
    todo.add("Item2");
    todo.add("Item3");
    todo.add("Item4");
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("myDefiDo's"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  title: Text("Add Your Do's"),
                  content: TextField(
                    onChanged: (String value){
                      todoTitle = value;
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: (){
                          createTodo();
                          Navigator.of(context).pop();

                        }, child: Text("Add"))
                  ],

                );
          });
        },
        child: Icon(
        Icons.add,
          color: Colors.white,
        ),
      ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("MyTodo").snapshots(),
          builder: (context, snapshots){

         if(snapshots.hasData) {
           return ListView.builder(
               shrinkWrap: true,
               itemCount: snapshots.data?.docs.length,
               itemBuilder: (context, index) {
                 DocumentSnapshot documentSnapshot = snapshots.data
                     ?.docs[index];
                 return Dismissible(
                   onDismissed: (direction) {
                     deleteToDo(documentSnapshot["todoTitle"]);
                   },
                   key: Key(documentSnapshot["todoTitle"]),
                   child: Card(
                     elevation: 4,
                     margin: EdgeInsets.all(8),

                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(8)),
                     child: ListTile(
                       title: Text(documentSnapshot["todoTitle"]),
                       trailing: IconButton(
                           icon: Icon(
                             Icons.delete,
                             color: Colors.red,
                           ),
                           onPressed: () {
                             deleteToDo(documentSnapshot["todoTitle"]);
                           }),
                     ),
                   ),
                 );
               }
           );
         }
         else{
           return Align(
             alignment: FractionalOffset.bottomCenter,
             child: CircularProgressIndicator(),
           );
         }
      })
    );
    }
}




