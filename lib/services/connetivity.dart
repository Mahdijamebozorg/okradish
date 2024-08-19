import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class Connection extends GetxService {
  bool isSyncing = false;
  void onConnected(Function func) {
    //listen to device internet changes
    Connectivity().onConnectivityChanged.listen(
      (event) async {
        //if internet is on
        if (event == ConnectivityResult.wifi ||
            event == ConnectivityResult.mobile) {
          if (!isSyncing) {
            isSyncing = true;
            try {
              await func;
            } finally {
              isSyncing = false;
            }
          }
        }

        //if internet is off
        else {}
      },
    );
  }
}
