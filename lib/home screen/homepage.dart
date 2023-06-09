import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../listofnotes/list.dart';
import '../listofnotes/sqlite_service.dart';
import '../newnote.dart';
import '../editnote.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<User> _notesList = [];
  List<String> _filteredData = [];
  final TextEditingController _noteSearchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  Future<void> _fetchNotes() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.initDB();
    final notesList = await dbHelper.retrieveUsers();
    setState(() {
      _notesList = notesList;
      _filteredData = notesList.map((note) => note.noteTitle).toList();
      _noteSearchController.addListener(_performSearch);
    });
  }

  Future<void> _performSearch() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 290));
    setState(() {
      _filteredData = _notesList
          .where((note) => note.noteTitle
              .toLowerCase()
              .contains(_noteSearchController.text.toLowerCase()))
          .map((note) => note.noteTitle)
          .toList();
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _noteSearchController.removeListener(_performSearch);
    _noteSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _noteSearchController.clear();
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade100,
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Text(
            "Notes",
            style: GoogleFonts.gochiHand(
                textStyle: const TextStyle(fontSize: 29)),
          ),
          actions: [
            Container(
              width: 200,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.brown.shade300,
              ),
              child: TextField(
                controller: _noteSearchController,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: GoogleFonts.gochiHand(
                    textStyle: const TextStyle(fontSize: 25),
                  ),
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.search_outlined),
                ),

                style: GoogleFonts.gochiHand(
                    textStyle: const TextStyle(fontSize: 28)),
              ),
            )
          ],
        ),
        body: _isLoading
            ? const Center(
                child: SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    color: Colors.brown,
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(10),
                child: ListView.builder(
                  itemCount: _filteredData.length,
                  itemBuilder: (context, index) {
                    final note = _notesList.firstWhere(
                        (note) => note.noteTitle == _filteredData[index]);
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown.shade300,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditNoteScreen(note: note)));
                        },
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditNoteScreen(note: note)));
                            },
                            icon: const Icon(Icons.edit),
                          ),
                          title: Text(
                            note.noteTitle,
                            style: GoogleFonts.gochiHand(
                              textStyle: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Text(
                            '${note.noteDate}          ${note.noteTime}',
                            style: GoogleFonts.gochiHand(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewNoteDart()));
          },
          elevation: 40,
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
    );
  }
}
