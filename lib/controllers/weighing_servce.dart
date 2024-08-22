import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as mobile;
import 'package:flutter_web_bluetooth/flutter_web_bluetooth.dart' as web;
import 'package:okradish/constants/device.dart';

class WeighingServce extends GetxController {
  RxDouble weight = 100.0.obs;
  RxBool connected = false.obs;
  late mobile.BluetoothDevice device1;
  late web.BluetoothDevice device2;

  Future<void> init() async {
    if (kIsWeb) return;
    // listen to bluetooch
    await mobile.FlutterBluePlus.setLogLevel(mobile.LogLevel.verbose);
    mobile.FlutterBluePlus.adapterState
        .listen((mobile.BluetoothAdapterState state) async {
      // if off
      if (!await isBluetoothEnabled()) {
        connected.value = false;
        await turnOnBluetooth();
      }
      // if on
      else {
        // if not connected
        if (!connected.value) {
          // search and connect to device
          await connect1();
          connected.value = true;
          log(name: "WEIGHT", "remoteId : ${device1.remoteId.str}");
        }
        try {
          final services = await device1.discoverServices();
          final service =
              services.firstWhere((s) => s.uuid.str == DeviceKeys.serviceUUID);
          final char = service.characteristics
              .firstWhere((ch) => ch.uuid.str == DeviceKeys.chareUUID);

          await char.setNotifyValue(true, timeout: 20);
          char.onValueReceived.listen((value) {
            log(name: "WEIGHT", 'value list: $value');
            int w = value[0];
            log(name: "WEIGHT", 'weight: $w');
            weight.value = w.toDouble();
            update(['weight']);
          });
        }
        // if device does not have char
        catch (e) {
          log(name: "WEIGHT", "wrong device : ${device1.advName}");
          if (Platform.isAndroid) await device1.disconnect();
          connected.value = false;
        }
      }
    });
  }

  Future<bool> isBluetoothEnabled() async {
    await mobile.FlutterBluePlus.isOn;
    await Future.delayed(const Duration(milliseconds: 100));
    final state = await mobile.FlutterBluePlus.adapterState.first;
    // Wait for scanning to stop
    if (state == mobile.BluetoothAdapterState.on) {
      return true;
    }
    return false;
  }

  Future<void> turnOnBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await mobile.FlutterBluePlus.turnOn();
      } catch (e) {}
    }
  }

  Future connect1() async {
    await for (var result in mobile.FlutterBluePlus.onScanResults) {
      log(name: "WEIGHT", result.toString());
      if (result.isNotEmpty) {
        for (var r in result) {
          if (r.device.advName == DeviceKeys.name) {
            device1 = r.device;
            if (!r.device.isConnected) {
              await r.device.connect(autoConnect: true);
            }
          }
        }
      }
    }
  }

  Future<void> initWeb() async {
    if (!kIsWeb) return;
    final fwb = web.FlutterWebBluetooth.instance;

    // listen to bluetooch
    fwb.advertisements.listen((web.AdvertisementReceivedEvent state) async {
      // if not connected
      if (!connected.value) {
        // search and connect to device
        await connect2();
        connected.value = true;
        log(name: "WEIGHT", "remoteId : ${device1.remoteId.str}");
      }
      try {
        final services = await device1.discoverServices();
        final service =
            services.firstWhere((s) => s.uuid.str == DeviceKeys.serviceUUID);
        final char = service.characteristics
            .firstWhere((ch) => ch.uuid.str == DeviceKeys.chareUUID);

        await char.setNotifyValue(true, timeout: 20);
        char.onValueReceived.listen((value) {
          log(name: "WEIGHT", 'value list: $value');
          int w = value[0];
          log(name: "WEIGHT", 'weight: $w');
          weight.value = w.toDouble();
          update(['weight']);
        });
      }
      // if device does not have char
      catch (e) {
        log(name: "WEIGHT", "wrong device : ${device1.advName}");
        if (Platform.isAndroid) device2.disconnect();
        connected.value = false;
      }
    });
  }

  Future connect2() async {
    web.FlutterWebBluetooth.instance.requestLEScan(
      web.LEScanOptionsBuilder(
        [
          web.RequestFilterBuilder(
            name: DeviceKeys.name,
            services: [DeviceKeys.serviceUUID],
          )
        ],
      ),
    );
    device2 = await web.FlutterWebBluetooth.instance.requestDevice(
      web.RequestOptionsBuilder(
        [
          web.RequestFilterBuilder(
            name: DeviceKeys.name,
            services: [DeviceKeys.serviceUUID],
          )
        ],
      ),
    );
  }
}
