import 'package:flutter/material.dart';
import 'package:simplified_singleton/sqflite/DataModel.dart';

class DataCard extends StatelessWidget {
  const DataCard(
      {Key? key,
      required this.data,
      required this.edit,
      required this.index,
      required this.delete})
      : super(key: key);
  final DataModel data;
  final Function edit;
  final Function delete;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              edit(index);
            },
          ),
        ),
        title: Text(data.title),
        subtitle: Text(data.subtitle),
        trailing: CircleAvatar(
          backgroundColor: Colors.red,
          child: IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () {
              delete(index);
            },
          ),
        ),
      ),
    );
  }
}
