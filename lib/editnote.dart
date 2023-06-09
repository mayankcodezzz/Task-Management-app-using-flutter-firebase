import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internday7/home%20screen/homepage.dart';
import 'package:intl/intl.dart';
import '../listofnotes/list.dart';
import '../listofnotes/sqlite_service.dart';

class EditNoteScreen extends StatefulWidget {
  final User note;

  const EditNoteScreen({required this.note, Key? key}) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();
  late DatabaseHelper dbHelper;
  late User _user;

  late List<User> _notesList = []; // initialize the _notesList variable


  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();

    _user = widget.note;
    _noteTitleController.text = _user.noteTitle;
    _noteContentController.text = _user.noteContent;
  }

  Future<void> _fetchNotes() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.initDB();
    final notesList = await dbHelper.retrieveUsers();
    setState(() {
      _notesList = notesList;
    });
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
  }


  Future<void> _updateNote() async {
    DateTime now = DateTime.now();
    String nDate = DateFormat.yMd().format(now);
    String nTime = DateFormat.jm().format(now);
    String noteDate = nDate;
    String noteTime = nTime;

    User updatedNote = User(
      id: _user.id,
      noteTitle: _noteTitleController.text,
      noteContent: _noteContentController.text,
      noteTime: noteTime,
      noteDate: noteDate,
    );
    await updateUser(updatedNote);
  }

  Future<int> updateUser(User user) async {
    return await dbHelper.updateUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade100,
      appBar: AppBar(
        title: Text(
          "Edit Note",
          style: GoogleFonts.gochiHand(
            textStyle: const TextStyle(fontSize: 32),
          ),
        ),
        actions: [

          IconButton(
            onPressed: () {
              //_updateNote();
              showDialog(
                  context: context,
                  builder: (ctx) => (AlertDialog(
                        title: const Text('Commit'),
                        content: const Text(
                            'Are You Sure For Updates you have made?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              _updateNote();
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('Approve'),
                            onPressed: () {
                              _updateNote();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                            },
                          ),

                        ],

                      )));
            },
            icon: const Icon(Icons.save),
          ),
          IconButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (ctx) => (AlertDialog(
                        title: const Text('DELETE'),
                        content: const Text(
                            'Are You Sure To Delete This Note'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              _updateNote();
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('Approve'),
                            onPressed: () async {
                              final dbHelper = DatabaseHelper();
                              await dbHelper.initDB();
                              await dbHelper.deleteUser(_user.id!);
                              await _fetchNotes();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                            },
                          ),
                        ],
                      )));
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _noteTitleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              style: GoogleFonts.gochiHand(
                textStyle:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              getCurrentDate(),
              style: GoogleFonts.gochiHand(
                  textStyle: const TextStyle(
                fontSize: 20,
              )),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _noteContentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: 'Note',
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 20),
              ),
              style: GoogleFonts.gochiHand(
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getCurrentDate() {
  DateTime now = DateTime.now();
  String naDate = DateFormat.yMd().format(now);
  String naTime = DateFormat.jm().format(now);
  String Day = DateFormat('EEEEEEEEE').format(now);
  return "${naDate}   ${naTime} | ${Day}";
}
