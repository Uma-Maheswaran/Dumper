import 'dart:io';


import 'package:dumpr/utils/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

import 'file_icon.dart';

class FileItem extends StatelessWidget {
  final FileSystemEntity file;
  final Function? popTap;

  FileItem({
    Key? key,
    required this.file,
    this.popTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => OpenFile.open(file.path),
      contentPadding: const EdgeInsets.all(0),
      leading: FileIcon(file: file),
      title: Text(
        basename(file.path),
        style: const TextStyle(fontSize: 14,color: Colors.white),
        maxLines: 2,
      ),
      subtitle: Text(
        '${FileUtils.formatBytes(File(file.path).lengthSync(), 2)},'
        ' ${FileUtils.formatTime(File(file.path).lastModifiedSync().toIso8601String())}',
        style: const TextStyle(color: Colors.white),
      ),

    );
  }
}
