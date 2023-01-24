import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final TextEditingController _controller1 = TextEditingController();
final TextEditingController _controller2 = TextEditingController();

DateFormat formatter = DateFormat("yyyy-MM-dd");
DateTime date = DateTime.now();
TimeOfDay time = TimeOfDay.now();

String formattedDate = formatter.format(date);

Map<int, ToDo> toDoList = HashMap();
int id = 0;

class ToDo {
  String task = "";
  String description = "N/A";
  String deadline = "";
  bool? status = false;
  int id;

  String getTask() => task;

  String getDescription() => description;

  String getDeadline() => deadline;

  bool? getStatus() => status;

  int getID() => id;

  ToDo(this.task, this.description, this.deadline, this.id, this.status);
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Column(
        children: displayItem(),
      ),
    );
  }

  Widget buildItem(BuildContext context, idx) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => Detail(idx: idx)))
            .then((value) => setState(() {}));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            ListTile(
              leading: Checkbox(
                checkColor: Colors.white,
                onChanged: (bool? value) {
                  setState(() {
                    toDoList[idx]!.status = value!;
                  });
                },
                value: toDoList[idx]!.status,
              ),
              title: Text(toDoList[idx]!.task),
              subtitle: Text(toDoList[idx]!.deadline),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    toDoList.remove(idx);
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> displayItem() {
    final List<Widget> list = [];
    for (var key in toDoList.keys) {
      list.add(buildItem(context, key));
    }
    return list;
  }
}

class Detail extends StatefulWidget {
  final int idx;

  const Detail({super.key, required this.idx});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.lightBlueAccent),
        body: Container(
            child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(toDoList[widget.idx]!.task,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 30)),
                    Text(
                      toDoList[widget.idx]!.deadline,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Colors.grey),
                    )
                  ],
                ),
                const Divider(thickness: 1.0, color: Colors.black),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      "Description: ${toDoList[widget.idx]!.description}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
          ),
        )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => alert(context),
        tooltip: "Edit Task",
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit)
      ),
    );
  }

  Future<Future> alert(BuildContext context) async {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  changeItems(widget.idx, _controller1.text, _controller2.text,
                      "Date: $formattedDate    Time: ${time.hour}:${time.minute}");
                },
                child: const Text('Save'),
              ),
            ],
          );
        }
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());

  void changeItems(int idx, String task, String description, String time){
    setState(() {
      if(task != "") toDoList[idx]!.task = task;
      toDoList[idx]!.description = description;
      toDoList[idx]!.deadline = time;
    });

    _controller1.clear();
    _controller2.clear();
  }
}
