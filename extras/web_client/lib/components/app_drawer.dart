import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tank_manager/model/app_data.dart';
import 'package:tank_manager/model/tank.dart';
import 'package:tank_manager/model/tc_interface.dart';
import 'package:tank_manager/model/version.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  showAlertDialog(String message, BuildContext context) async {
    // set up the button
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(message),
      content: const Text(
        'Error connecting to Tank Controller. This is likely due to an incorrect IP address.',
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget addTankButton(
    TextEditingController nameController,
    TextEditingController ipController,
    AppData appData,
  ) {
    return Align(
      alignment: Alignment.topRight,
      child: FloatingActionButton(
        onPressed: () async {
          var newTank = Tank(nameController.text, ipController.text);
          try {
            await appData.addTank(newTank);
          } catch (e) {
            showAlertDialog(e.runtimeType.toString(), context);
          }
        },
        tooltip: 'Add Tank',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget removeTankButton(
    TextEditingController nameController,
    TextEditingController ipController,
    AppData appData,
  ) {
    return Align(
      alignment: Alignment.topRight,
      child: FloatingActionButton(
        onPressed: () {
          appData.removeTank(appData.currentTank);
          appData.clearTank();
        },
        tooltip: 'Remove Tank',
        child: const Icon(Icons.delete_sharp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appData = AppData.instance();
    final ipController = TextEditingController();
    final nameController = TextEditingController();
    List<Widget> tiles = <Widget>[];
    for (var tank in appData.tankList) {
      tiles.add(tile(tank));
    }
    return Drawer(
      backgroundColor: Colors.grey.shade600,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                drawerHeader(context),
                ...tiles,
                field(nameController, 'Name', 'Tank 99'),
                field(ipController, 'IP', '000.000.000.000'),
                addTankButton(nameController, ipController, appData),
                removeTankButton(nameController, ipController, appData),
              ],
            ),
          ),
          const Align(
            alignment: FractionalOffset.bottomCenter,
            child: Text(gitVersion),
          ),
        ],
      ),
    );
  }

  Widget drawerHeader(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: DrawerHeader(
        child: Image.asset(
          'lib/assets/oap.png',
        ),
      ),
    );
  }

  Widget field(var controller, var label, var hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hint,
      ),
    );
  }

  Future<void> updateDisplay() async {
    var appData = AppData.instance();
    var tcInterface = TcInterface.instance();
    String value = await tcInterface.get(appData.currentTank.ip, 'display');
    appData.display = value; // setter notifies listeners of change
  }

  Widget tile(var selected) {
    return ListTile(
      title: Text(
        selected.name,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        AppData.instance().currentTank = selected;
        unawaited(updateDisplay());
        Navigator.pop(context);
      },
    );
  }
}