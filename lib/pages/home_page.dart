import 'package:dumpr/provider/storage_provider.dart';
import 'package:dumpr/utils/constants.dart';
import 'package:dumpr/utils/navigate_helper.dart';
import 'package:dumpr/widgets/circular_bar_indicator.dart';
import 'package:dumpr/widgets/explorer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Provider.of<StorageProvider>(context, listen: false)
          .searchStorageDevice();
    });
  }

  refresh(BuildContext context) async{
    await Provider.of<StorageProvider>(context, listen: false).searchStorageDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          Constants.appName,
          style: const TextStyle(fontSize: 25.0),
        ),
      ),
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: () => refresh(context),
        child: ListView(
          padding: const EdgeInsets.only(top: 70.0),
          children: const <Widget>[
            StorageDevice(),
          ],
        ),
      ), 
      
    );
  }
}

class StorageDevice extends StatelessWidget {
  const StorageDevice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<StorageProvider>(
        builder: (BuildContext context, storageProvider, Widget? child){
          if (storageProvider.storageLoading) {
            return const SizedBox(height: 100, child: CircularProgressIndicator());
          }
          return InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                NavigateHelper.pushPage(
                  context,
                  Explorer(title: "Internal Storage", path: storageProvider.internalStoragePath),
                );
              },
              child: CircularBarIndicator(percent: calculatePercent(storageProvider.usedSpace, storageProvider.totalSpace), title: "Internal Storage"));
        }
    );
  }
  calculatePercent(int usedSpace, int totalSpace) {
    return double.parse((usedSpace / totalSpace * 100).toStringAsFixed(0));
  }
}
