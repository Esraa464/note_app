import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sql_note_app/views/homePage/widgets/grid_Item.dart';
import 'package:sql_note_app/views/states.dart';

import 'controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        // lazy: true,
        create: (context) => NoteController()..createDB(),
        child: BlocConsumer<NoteController, NoteStates>(
          listener: (context, state) {},
          builder: (context, state) {
            final controller = NoteController.of(context);

            return Scaffold(
              appBar: AppBar(
                title: const Text('Notes'),
              ),
              body: controller.notes == null
                  ? const Center(child: Text('There is no notes'))
                  : GridView.count(
                      crossAxisSpacing: 11,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      crossAxisCount: 2,
                      mainAxisSpacing: 11,
                      children: List.generate(
                          controller.notes!.length,
                          (index) => GridItem(
                                note: controller.notes![index],
                                onTap: () {
                                  controller.deleteNote(
                                      noteId: controller.notes![index].noteId);
                                  print('deleted successfully');
                                },
                              )),
                    ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Note Id'),
                                controller: controller.noteIdController,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Note title'),
                                controller: controller.titleController,
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                    labelText: 'Note body',
                                    alignLabelWithHint: true),
                                controller: controller.contentController,
                                minLines: 10,
                                maxLines: 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    controller.addNote(context);
                                    print('added successfully');
                                    print(
                                        '========================================');
                                  },
                                  child: const Text('Add Note'))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              ),
            );
          },
        ));
  }
}
