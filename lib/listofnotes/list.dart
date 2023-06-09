class User {
  //creating class variables
  int? id;
  String noteTitle;
  String noteContent;
  String noteTime;
  String noteDate;
  //constructor initializing values when object of class is created
  User(
      {
        this.id,
      required this.noteTitle,
      required this.noteContent,
      required this.noteTime,
      required this.noteDate});
 // used to dynamically map the values
  User.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        noteTitle = res["noteTitle"],
        noteContent = res["noteContent"],
        noteTime = res["noteTime"],
        noteDate = res["noteDate"];
 //used to map and decode the objects to the lowest level
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'noteTime': noteTime,
      'noteDate': noteDate
    };
  }
}
