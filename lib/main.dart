import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_appointy_todo_task/model/todos.dart';
import 'package:flutter_appointy_todo_task/service/api-service.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Todos _todos = Todos();
  List<Todos> todoList = List();
  String type="add";
  bool todoStatus = false;
  final _ctrlTitle = TextEditingController();
  final _ctrlDescription = TextEditingController();



  void _getAllTodos() async {
    List<Todos> _todoList = await getTodos();
     setState(() {
       print(_todoList);
    todoList = _todoList;
     });
  }

  void _getDelete(String id) async {
    List<Todos> _todoList = await deleteTodo(id);
    setState(() {
      print(_todoList);
      todoList = _todoList;
    });
  }

  void _getMark(String id,bool status) async {
    _todos = Todos(
        completed: status);
    List<Todos> _todoList = await markTodo(id,_todos);
    setState(() {
      print(_todoList);
     _getAllTodos();
    });
  }

  void _addTodo() {
    _todos = Todos(
        title: _ctrlTitle.text,
        description: _ctrlDescription.text,
        completed: false);
    addTodo(_todos).then((value) {
      Navigator.of(context).pop();
      _getAllTodos();
    });
  }

  void _editTodo(String id) {
    _todos = Todos(
        title: _ctrlTitle.text,
        description: _ctrlDescription.text,
        completed: false);
    editTodo(id,_todos).then((value) {
      Navigator.of(context).pop();
      // setState(() {
      _getAllTodos();
      // });
    });
  }


  Future<void> _showConfirmationDialog(String id,bool status,String message,String type) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Message') ,
          content: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: ListBody(
                  children: [

                    Text(message,style: TextStyle(fontWeight: FontWeight.bold),)


                  ],
                )),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child:  Text('Ok'),
              onPressed: () {
                type=="delete" ? _getDelete(id) :    _getMark(id,status);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> _showMyDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: type=="add" ? Text('Add Todo') : Text('Edit Todo'),
          content: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(5),
                child: ListBody(
                  children: [
                    TextFormField(
                        controller: _ctrlTitle,
                        decoration: InputDecoration(hintText: 'Title')),
                    SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _ctrlDescription,
                      decoration: InputDecoration(hintText: 'Description'),
                    ),


                  ],
                )),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: type=="add" ? Text('Add ') : Text('Upadte'),
              onPressed: () {
                type=="add" ? _addTodo() : _editTodo(id);
              },
            ),
          ],
        );
      },
    );
  }



  @override
  void initState() {
    super.initState();
   _getAllTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Demo'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _getAllTodos(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          Todos item = todoList[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    color: Color(0xFFB7B7B7).withOpacity(.16),
                  ),
                ],
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize:
                        MainAxisSize.min,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              print('onPressed');
                              setState(() {
                               // _getDelete(item.id);
                                _showConfirmationDialog(item.id, item.completed == false ?  true : false, "Are you sure ,want to delete this data", "delete");



                              });
                            },
                            color: Color(0xFFf48b15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(50),
                                    bottomRight: Radius.circular(50))),
                            child: Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        mainAxisSize:
                        MainAxisSize.min,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              print('onPressed');
                              setState(() {

                                _showConfirmationDialog(item.id, item.completed == false ?  true : false, "Are you sure,have you completed your todo", "nodeleted");


                              });
                            },
                            color:item.completed == false ?  Color(0xFFe00202) :  Color(0xFF60b808),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    bottomLeft: Radius.circular(50))),
                            child: item.completed == false ? Text("Pending",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),) :   Text("Completed",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


                ListTile(
                  title: Text(item.title != null ? item.title : '',
                      style: Theme.of(context).textTheme.headline6),
                  subtitle: Text(item.description != null ? item.description : '',
                      style: Theme.of(context).textTheme.subtitle1),
                  onTap: () {

                    setState(() {
                      type="edit";

                      _ctrlTitle.text=item.title;
                      _ctrlDescription.text=item.description;
                      _showMyDialog(item.id);
                    });

                  },
                ),

              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>{
    setState(() {
        type="add";

        _ctrlTitle.text="";
        _ctrlDescription.text="";
        _showMyDialog("");

        })

        } ,
        tooltip: 'Add Todo',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
