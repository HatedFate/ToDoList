import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'todo.dart';

final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();

DateFormat formatter = DateFormat("yyyy-MM-dd");
DateTime date = DateTime.now();
TimeOfDay time = TimeOfDay.now();

String formattedDate = formatter.format(date);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: Align(alignment: Alignment.topLeft, child: Main()),
      floatingActionButton: FloatingActionButton(
        onPressed: () => alert(context),
        tooltip: "Add Tasks",
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Future> alert(BuildContext context) async {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              'New Task',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.brown),
            ),
            content: SizedBox(
              height: height * 0.35,
              width: width,
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _controller1,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Task',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: _controller2,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        hintText: 'Description',
                        hintStyle: const TextStyle(fontSize: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 100,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? newTime = await pickTime();
                            if (newTime == null) return;
                            setState(() => time = newTime);
                          },
                          child: const Text("Select Time"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            DateTime? newDate = await pickDate();
                            if (newDate == null) return;
                            setState(() => date = newDate);
                          },
                          child: const Text("Select Date"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(),
                child: const Text('Cancel'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  addItems(_controller1.text, _controller2.text,
                      "Date: $formattedDate    Time: ${time.hour}:${time.minute}");
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());

  void addItems(String task, String description, String deadline) {
    setState(() {
      if (task == "") return;
      ToDo item = ToDo(task, description, deadline, id, false);
      toDoList[id] = item;
      ++id;
    });
    _controller1.clear();
    _controller2.clear();
  }
}
