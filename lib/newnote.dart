import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internday7/home%20screen/homepage.dart';
import 'package:intl/intl.dart';

import 'listofnotes/list.dart';
import 'listofnotes/sqlite_service.dart';

class NewNoteDart extends StatefulWidget {
  const NewNoteDart({Key? key}) : super(key: key);

  @override
  State<NewNoteDart> createState() => _NewNoteDartState();
}

class _NewNoteDartState extends State<NewNoteDart> {
  final TextEditingController noteTitle = TextEditingController();
  final TextEditingController noteContent = TextEditingController();
  late DatabaseHelper dbHelper;
  late User _user;

  Future<void> addingUser() async {
    DateTime now = DateTime.now();
    String nDate = DateFormat.yMd().format(now);
    String nTime = DateFormat.jm().format(now);
    String noteDate = nDate;
    String noteTime = nTime;

    User user = User(
      noteTitle: noteTitle.text,
      noteContent: noteContent.text,
      noteTime: noteTime,
      noteDate: noteDate,
    );
    await addUser(user);

    setState(() {});
  }

  Future<int> addUser(User user) async {
    return await dbHelper.insertUser(user);
  }

  Future<int> updateUser(User user) async {
    return await dbHelper.updateUser(user);
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    if ((noteTitle.text).isEmpty){
      AlertDialog alert = AlertDialog(
        title:const Text("Alert"),
        content:const Text("Input title is empty"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:const Text("ok"))
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else if((noteTitle.text).isEmpty){
      AlertDialog alert = AlertDialog(
        title:const Text("Alert"),
        content:const Text("note is empty"),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child:const Text("ok"))
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
    else{
      addingUser();
      setState(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MyHomePage()));
      });
    }
  }

  String? valueText;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.initDB().whenComplete(() async {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text(
          "Note",
          style:
              GoogleFonts.gochiHand(textStyle: const TextStyle(fontSize: 30)),
        ),
        actions: [
          IconButton(onPressed: (){
            _displayTextInputDialog(context);},
              icon:const Icon(Icons.save_alt)
          )
        ],
      ),
      body: Column(children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: noteTitle,
              style: GoogleFonts.gochiHand(
                  textStyle: const TextStyle(
                fontSize: 29,
              )),
              decoration: const InputDecoration(hintText: "Input title"),
              maxLines: null,
            ),
          ),
        ),
        Text(
          getCurrentDate(),
          style: GoogleFonts.gochiHand(
              textStyle: const TextStyle(
            fontSize: 20,
          )),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: noteContent,
              style: GoogleFonts.gochiHand(
                  textStyle: const TextStyle(
                fontSize: 29,
              )),
              decoration: const InputDecoration(
                  hintText: "write from here.....", border: InputBorder.none),
              maxLines: null,
              expands: true,
            ),
          ),
        ),
      ]),
    );
  }
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  String naDate = DateFormat.yMd().format(now);
  String naTime = DateFormat.jm().format(now);
  String day = DateFormat('EEEEEEEEE').format(now);
  return "$naDate   $naTime | $day";
}
