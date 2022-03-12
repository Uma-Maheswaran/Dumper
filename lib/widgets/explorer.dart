import 'dart:io';

import 'package:dumpr/utils/dialogs.dart';
import 'package:dumpr/utils/file_utils.dart';
import 'package:dumpr/widgets/path_bar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;

import 'dir_item.dart';
import 'file_item.dart';

class Explorer extends StatefulWidget {
  final String path;
  final String title;
  const Explorer({
    Key? key,
    required this.title,
    required this.path,
  }) : super(key: key);

  @override
  _ExplorerState createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer>  with WidgetsBindingObserver{
  late String path;
  List<String> paths = <String>[];

  List<FileSystemEntity> files = <FileSystemEntity>[];
  bool showHidden = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getFiles();
    }
  }

  getFiles() async {
    try {
      //var provider = Provider.of<CategoryProvider>(context, listen: false);
      Directory dir = Directory(path);
      List<FileSystemEntity> dirFiles = dir.listSync();
      files.clear();
      setState(() {});
      for (FileSystemEntity file in dirFiles) {
        if (!showHidden) {
          if (!pathlib.basename(file.path).startsWith('.')) {
            files.add(file);
            setState(() {});
          }
        } else {
          files.add(file);
          setState(() {});
        }
      }

      files = FileUtils.sortList(files,0);
    } catch (e) {
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast('Permission Denied! cannot access this Directory!');
        navigateBack();
      }
    }
  }
  @override
  void initState() {
    super.initState();
    path = widget.path;
    getFiles();
    paths.add(widget.path);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  navigateBack() {
    paths.removeLast();
    path = paths.last;
    setState(() {});
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (paths.length == 1) {
          return true;
        } else {
          paths.removeLast();
          setState(() {
            path = paths.last;
          });
          getFiles();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (paths.length == 1) {
                Navigator.pop(context);
              } else {
                navigateBack();
              }
            },
          ),
          elevation: 8,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title),
              Text(
                path,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: PathBar(
            paths: paths,
            icon: Icons.storage_rounded,
            onChanged: (index) {
              print(paths[index]);
              path = paths[index];
              paths.removeRange(index + 1, paths.length);
              setState(() {});
              getFiles();
            },
          ),
        ),
        backgroundColor: Colors.black,
        body: Visibility(
          replacement: const Center(child: Text('There\'s nothing here')),
          visible: files.isNotEmpty,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 20),
            itemCount: files.length,
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity file = files[index];
              if (file.toString().split(':')[0] == 'Directory') {
                return DirectoryItem(
                  popTap: (v) async {
                    if (v == 0) {
                      //renameDialog(context, file.path, 'dir');
                    } else if (v == 1) {
                     // deleteFile(true, file);
                    }
                  },
                  file: file,
                  tap: () {
                    paths.add(file.path);
                    path = file.path;
                    setState(() {});
                    getFiles();
                  },
                );
              }
              return FileItem(
                file: file,
                popTap: (v) async {

                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ),
    );
  }
}
