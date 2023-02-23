import 'package:flutter/material.dart';

import 'package:simplified_singleton/sqflite/DataModel.dart';

import 'DataCard.dart';
import 'Database.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController subtitleController = TextEditingController();
  List<DataModel> datas = [];
  bool fetching = true;
  int currentIndex = 0;
  late DB db;
  final key = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    db = DB();
    getData();
  }

  void getData() async {
    datas = await db.getData();
    setState(() {
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Sqflite Tutorial"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showMyDialogue();
          },
          child: const Icon(Icons.add),
        ),
        body: Center(
            child: fetching
                ? const CircularProgressIndicator()
                : ListView.separated(
                    itemCount: datas.length,
                    itemBuilder: (context, index) => DataCard(
                      data: datas[index],
                      edit: edit,
                      delete: delete,
                      index: index,
                    ),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 30,
                      );
                    },
                  )));
  }

  void showMyDialogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(14),
            content: Container(
              height: 150,
              child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'add title';
                          }
                        },
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'title'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: subtitleController,
                        validator: (value) {
                          if (value == '') {
                            return 'add subtitle';
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: 'subtitle'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DataModel dataLocal = DataModel(
                        title: titleController.text,
                        subtitle: subtitleController.text);
                    if (key.currentState!.validate()) {
                      db.insertData(dataLocal);
                      dataLocal.id = datas[datas.length - 1].id! + 1;
                      setState(() {
                        datas.add(dataLocal);
                      });
                      Navigator.pop(context);
                      titleController.clear();
                      subtitleController.clear();
                    }
                  },
                  child: const Text('SAVE'))
            ],
          );
        });
  }

  void showMyDialogueUpdate() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(14),
            content: Container(
              height: 150,
              child: Form(
                key: key,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == '') {
                            return 'add title';
                          }
                        },
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'title'),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: subtitleController,
                        validator: (value) {
                          if (value == '') {
                            return 'add subtitle';
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: 'subtitle'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    DataModel newData = datas[currentIndex];
                    if (key.currentState!.validate()) {
                      newData.subtitle = subtitleController.text;
                      newData.title = titleController.text;
                      db.update(newData, newData.id!);
                      setState(() {});
                      Navigator.pop(context);
                      titleController.clear();
                      subtitleController.clear();
                    }
                  },
                  child: const Text('UPDATE'))
            ],
          );
        });
  }

  void edit(index) {
    currentIndex = index;
    titleController.text = datas[index].title;
    subtitleController.text = datas[index].subtitle;
    showMyDialogueUpdate();
  }

  void delete(index) {
    db.delete(datas[index].id!);
    setState(() {
      datas.removeAt(index);
    });
  }
}
