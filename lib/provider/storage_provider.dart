import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class StorageProvider extends ChangeNotifier {
  List<FileSystemEntity> availableStorage = <FileSystemEntity>[];
  String internalStoragePath = "";
  int totalSpace = 0;
  int freeSpace = 0;
  int usedSpace = 0;
  bool storageLoading = true;

  searchStorageDevice() async {
    setStorageLoading(true);

    availableStorage.clear();
    List<Directory> dirList = (await getExternalStorageDirectories())!;
    availableStorage.addAll(dirList);
    notifyListeners();

    FileSystemEntity item = availableStorage[0];
    //print("paaath:"+availableStorage[0].path);
    internalStoragePath = item.path.split('Android')[0];
    setInternalStoragePath(internalStoragePath);

    MethodChannel platform = const MethodChannel('flutter.native/helper');
    var free = await platform.invokeMethod('getStorageFreeSpace');
    var total = await platform.invokeMethod('getStorageTotalSpace');
    setFreeSpace(free);
    setTotalSpace(total);
    setUsedSpace(total - free);

    //print("internal storage: "+internalStoragePath);
    setStorageLoading(false);
  }

  void setFreeSpace(value) {
    freeSpace = value;
    notifyListeners();
  }

  void setTotalSpace(value) {
    totalSpace = value;
    notifyListeners();
  }

  void setUsedSpace(value) {
    usedSpace = value;
    notifyListeners();
  }

  void setStorageLoading(value) {
    storageLoading = value;
    notifyListeners();
  }

  void setInternalStoragePath(value) {
    internalStoragePath = value;
    notifyListeners();
  }
}