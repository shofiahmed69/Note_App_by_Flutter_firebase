import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/register.dart';
import 'note_model.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var titleController = TextEditingController();

  var descController = TextEditingController();

  List<Note> notes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar : AppBar(
      backgroundColor: Colors.blueAccent,
      leading: Icon(Icons.home, color: Colors.white,),
      title: Text("Notes App", style: TextStyle(color: Colors.white),),
      actions: [
        IconButton(onPressed: (){
          getNotes();

        }, icon: Icon(Icons.refresh, color: Colors.white,))
      ],
    ),
      body: notes.isEmpty ? Center(
        child: Container(
          child: Text("no notes yet", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
        ),
      ) : ListView.builder(itemBuilder: (context, index){
       Note note = notes[index];
       return ListTile(
         leading: Text(note.title[0].toUpperCase(), style: TextStyle(fontSize: 20),),
         title: Text(note.title),
         subtitle: Text(note.desc),
         trailing: IconButton(onPressed: () async {
          await delNote(notes[index]);
          setState(() {
            
          });
         }, icon: Icon(Icons.delete, color: Colors.black,)),
         onTap: (){
          titleController.text = notes[index].title;
          descController.text = notes[index].desc;

           showDialog(context: context, builder: (context)=>AlertDialog(
             title: Text("update notes", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 TextField(
                   controller: titleController,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: "Enter Title",
                   ),
                 ),
                 SizedBox(height: 10,),
                 TextField(
                   controller: descController,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: "Enter Description",
                   ),
                 ),

               ],
             ),
             actions: [
               OutlinedButton(onPressed: (){
                 Navigator.pop(context);
               }, child: Text("cancel"),),
               ElevatedButton(onPressed: () async {
                 String title = titleController.text.trim();
                 String desc = descController.text.trim();
                 await addNote(Note(DateTime.now().toString(), title, desc), context);
                 setState(() {

                 });
                 updateNote(Note(notes[index].uid,title,desc));
                 Navigator.pop(context);
                 

               }, child: Text("update",style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),),

             ],
           ));

         },

       );
      }, itemCount: notes.length,),

      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text("add notes", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
           TextField(
             controller: titleController,
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               labelText: "Enter Title",
             ),
           ),
              SizedBox(height: 10,),
              TextField(
                controller: descController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Description",
                ),
              ),

            ],
          ),
          actions: [
            OutlinedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("cancel"),),
            ElevatedButton(onPressed: () async {
              String title = titleController.text.trim();
              String desc = descController.text.trim();
              await addNote(Note(DateTime.now().toString(), title, desc), context);
              setState(() {

              });
              Navigator.pop(context);
              titleController.text = "";
              descController.text = "";
            }, child: Text("add",style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),),

          ],
        ));
      }, child: Icon(Icons.add, color: Colors.white,), backgroundColor: Colors.blueAccent,),
    );
  }

  addNote(Note note, BuildContext context) async {
 FirebaseFirestore db = FirebaseFirestore.instance;
 await db.collection("notes").doc(note.uid.toString()).set(
   Note.toMap(note)
 ).then((value)=>{
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("note added successfully")))
 });

  }

  getNotes() async {
    notes.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("notes").get();
    for (DocumentSnapshot doc in snapshot.docs) {
      var Notedata = doc.data() as Map<String, dynamic>;
      notes.add(Note.fromMap(Notedata));
    }
    setState(() {

    });
}
  delNote(Note note) async {
    await FirebaseFirestore.instance.collection("notes").doc(note.uid).delete().then((value){
      print("deleted successfully");
      setState(() {

      });
    });

  }
  updateNote(Note note) async {
    await FirebaseFirestore.instance.collection("Notes").doc(note.uid).update(Note.toMap(note));
  }
}
