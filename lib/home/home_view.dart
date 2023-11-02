import 'package:flutter/material.dart';
import 'package:hive_db/boxes/boxes.dart';
import 'package:hive_db/model/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Hive Database"),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getNotesData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return box.isEmpty
              ? const Center(
                  child: Text(
                    "no data",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: ListTile(
                        tileColor: Colors.deepOrangeAccent.withOpacity(.4),
                        title: Text(
                          data[index].title,
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          data[index].description,
                          style: const TextStyle(color: Colors.black),
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  updateRecord(context, data[index]);
                                },
                                child: const Icon(Icons.edit),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () async {
                                  await data[index].delete();
                                },
                                child: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () async {
          addRecord(context);

          // var box = await Hive.openBox('Sohiab');
          // box.put('name', 'Muhammad Sohaib');
          // box.put('age', 23);
          // box.put('details', {"profession": "Developer", "company": "Elabd"});

          // print(box.get('name'));
          // print(box.get('age'));
          // print(box.get('details'));
          // print(box.get('details')['profession']);
          // print(box.get('details')['company']);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<dynamic> addRecord(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        hintText: "Enter Title"),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        hintText: "Enter Description"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final data = NotesModel(
                            title: titleController.text,
                            description: descriptionController.text,
                          );
                          final box = Boxes.getNotesData();
                          box.add(data);
                          data.save();
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Add"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> updateRecord(BuildContext context, NotesModel model) {
    descriptionController.text = model.description;
    titleController.text = model.title;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 300,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        hintText: "Enter Title"),
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        hintText: "Enter Description"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          model.title = titleController.text;
                          model.description = descriptionController.text;
                          model.save();
                          titleController.clear();
                          descriptionController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text("Update"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
