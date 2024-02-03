import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import "package:todo_app/data/database.dart";
import "package:todo_app/utils/dialog_box.dart";
import "package:todo_app/utils/todo_tile.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  // Controller
  final _controller = TextEditingController();
  // list of todo tasks

  TodoDatabase db = TodoDatabase();

  @override
  void initState() {
    // if this is the 1st open app
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChange(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow[200],
        appBar: AppBar(
          title: Text('To Do App'),
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: createNewTask, child: Icon(Icons.add)),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) => TodoTile(
              taskname: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => checkBoxChange(value, index),
              deleteFunction: (context) => deleteTask(index)),
        ));
  }
}
