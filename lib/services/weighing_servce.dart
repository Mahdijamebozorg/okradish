import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:OKRADISH/constants/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as mobile;
// import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as web;
import 'package:OKRADISH/constants/device.dart';

class WeighingServce extends GetxService {
  // web.BluetoothDevice? device2;

  final RxInt weight = 0.obs;
  final Rx<mobile.BluetoothDevice?> device = Rx(null);
  var _searchDevices = <mobile.ScanResult>[];
  final RxList<String> deviceNames = RxList([]);
  final RxBool isSearching = RxBool(false);

  Future<void> init() async {
    if (kIsWeb) return;
    // listen to bluetooch
    await mobile.FlutterBluePlus.setLogLevel(mobile.LogLevel.verbose);
    mobile.FlutterBluePlus.adapterState
        .listen((mobile.BluetoothAdapterState state) async {
      // if off
      if (state == mobile.BluetoothAdapterState.off) {
        weight.value = 0;
        device.value = null;
        await turnOnBluetooth();
        return;
      }
    });
  }

  //
  Future scan() async {
    if (device.value != null && device.value!.isConnected) {
      return;
    }
    try {
      isSearching.value = true;
      log(name: "WEIGHT", "Starting scan ...");

      // check connection
      if (mobile.FlutterBluePlus.adapterStateNow ==
          mobile.BluetoothAdapterState.off) {
        await turnOnBluetooth();
      }

      // check connection denied
      if (mobile.FlutterBluePlus.adapterStateNow ==
          mobile.BluetoothAdapterState.off) {
        isSearching.value = false;
        return;
      }

      await mobile.FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 5));

      final stream = mobile.FlutterBluePlus.onScanResults.listen((result) {
        _searchDevices = [];
        deviceNames.value = [];
        log(name: "WEIGHT", "Devices found: ${result.length.toString()}");
        for (var i = 0; i < result.length; i++) {
          if (result[i].advertisementData.advName.isNotEmpty) {
            if (!_searchDevices.contains(result[i])) {
              _searchDevices.add(result[i]);
            }
            if (!deviceNames.contains(result[i].advertisementData.advName)) {
              deviceNames.add(result[i].advertisementData.advName);
            }
          }
        }
      });
      // wait scan done
      await mobile.FlutterBluePlus.isScanning
          .where((val) => val == false)
          .first;
      await stream.cancel();

      isSearching.value = false;
    } catch (e) {
      log(name: "WEIGHT", e.toString());
      isSearching.value = false;
    }
  }

  //
  Future<String> connectToDevice(int index) async {
    try {
      if (_searchDevices[index].advertisementData.advName != DeviceKeys.name) {
        return Messages.wrongDevice;
      }

      await _searchDevices[index].device.connect(autoConnect: false);
      device.value = _searchDevices[index].device;
      final services = await device.value!.discoverServices();
      final service =
          services.firstWhere((s) => s.uuid.str == DeviceKeys.serviceUUID);
      final char = service.characteristics
          .firstWhere((ch) => ch.uuid.str == DeviceKeys.chareUUID);
      // listen to data
      await char.setNotifyValue(true);
      char.onValueReceived.listen(
        (value) {
          ByteBuffer buffer = new Int8List.fromList(value).buffer;
          ByteData byteData = new ByteData.view(buffer);
          weight.value = byteData.getInt16(0, Endian.little);
          // var strout = String.fromCharCodes(value);
          // strout = strout.trim();
          // weight.value = int.parse(strout);
        },
      );
      return "";
    } catch (e) {
      return e.toString();
    }
  }

  //
  Future<void> turnOnBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await mobile.FlutterBluePlus.turnOn();
      } catch (e) {}
    }
  }

  // Future<void> initWeb() async {
  //   if (!kIsWeb) return;
  //   final fwb = web.FlutterWebBluetooth.instance;

  //   // listen to bluetooch
  //   fwb.advertisements.listen((web.AdvertisementReceivedEvent state) async {
  //     // if not connected
  //     if (!connected.value) {
  //       // search and connect to device
  //       await connect2();
  //       connected.value = true;
  //       log(name: "WEIGHT", "remoteId : ${device1!.remoteId.str}");
  //     }
  //     try {
  //       final services = await device1!.discoverServices();
  //       final service =
  //           services.firstWhere((s) => s.uuid.str == DeviceKeys.serviceUUID);
  //       final char = service.characteristics
  //           .firstWhere((ch) => ch.uuid.str == DeviceKeys.chareUUID);

  //       await char.setNotifyValue(true, timeout: 20);
  //       char.onValueReceived.listen((value) {
  //         log(name: "WEIGHT", 'value list: $value');
  //         int w = value[0];
  //         log(name: "WEIGHT", 'weight: $w');
  //         weight.value = w.toDouble();
  //         update(['weight']);
  //       });
  //     }
  //     // if device does not have char
  //     catch (e) {
  //       log(name: "WEIGHT", "wrong device : ${device1!.advName}");
  //       if (Platform.isAndroid) device2!.disconnect();
  //       connected.value = false;
  //     }
  //   });
  // }

  // Future connect2() async {
  //   web.FlutterWebBluetooth.instance.requestLEScan(
  //     web.LEScanOptionsBuilder(
  //       [
  //         web.RequestFilterBuilder(
  //           name: DeviceKeys.name,
  //           services: [DeviceKeys.serviceUUID],
  //         )
  //       ],
  //     ),
  //   );
  //   device2 = await web.FlutterWebBluetooth.instance.requestDevice(
  //     web.RequestOptionsBuilder(
  //       [
  //         web.RequestFilterBuilder(
  //           name: DeviceKeys.name,
  //           services: [DeviceKeys.serviceUUID],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
