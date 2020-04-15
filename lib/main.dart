import 'package:flutter/material.dart';

void main() => runApp(TodoListApp());

class Todo {
  String what;
  bool done;
  Todo(this.what) : done = false;

  void toggleDone() => done = !done;
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({
    Key key,
  }) : super(key: key);

  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Todo> _todos;

  int get _doneCount => _todos.where((todo) => todo.done).length;

  @override
  void initState() {
    _todos = [
      Todo("Shopping"), 
      Todo("play soccer"), 
      Todo("go fishing")
    ];
    super.initState();
  }

  _removeChecked() {
    List<Todo> pending = [];
    for (var todo in _todos) {
      if (!todo.done) pending.add(todo);
    }

    setState(() => _todos = pending);
  }

  @override
  Widget build(BuildContext context) {
    _maybeRemoveChecked() {
      if (_doneCount == 0) {
        return;
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirmation"),
          content: Text("정말 삭제하시겠습니까?"),
          actions: <Widget>[
            FlatButton(
              child: Text("취소"),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),
            FlatButton(
              child: Text("확인"),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
          ],
        )
      ).then((confirm) {
        if (confirm) {
          _removeChecked();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: _maybeRemoveChecked,
            // onPressed: _removeChecked,
          )
        ],
      ),
      body: ListView.builder(
          itemCount: _todos.length,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              setState(() {
                //_todos[index].done = !_todos[index].done;
                _todos[index].toggleDone();
              });
            },
            child: ListTile(
              leading: Checkbox(
                value: _todos[index].done,
                onChanged: (checked) {
                  setState(() =>_todos[index].done = checked);
                },
              ),
              title: Text(_todos[index].what,
                  style: TextStyle(
                      decoration: _todos[index].done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none)),
            ),
          )),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NewTodoPage()
                )
              ).then((what) {
                  setState(() {
                    _todos.add(Todo(what));
                  });
              });
            },
          ),
    );
  }
}

class NewTodoPage extends StatefulWidget {
  @override
  _NewTodoPageState createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Todo..."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _controller,
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
                // Navigator.of(context).pop(_controller.text);
              },
            ),
            RaisedButton(
              child: Text("save"),
              onPressed: (){
                Navigator.of(context).pop(_controller.text);
              },
            )
          ],
        ),
      ),
    );
  }
}
