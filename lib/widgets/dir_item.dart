import 'dart:io';


import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DirectoryItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function tap;
  final Function? popTap;

  const DirectoryItem({
    Key? key,
    required this.file,
    required this.tap,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => tap(),
      contentPadding: const EdgeInsets.all(0),
      leading: const SizedBox(
        height: 40,
        width: 40,
        child: Center(
          child: Icon(
            Icons.folder,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(
        basename(file.path),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        maxLines: 2,
      ),
    );
  }
}
