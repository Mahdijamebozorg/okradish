import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:OKRADISH/component/button_style.dart';
import 'package:OKRADISH/component/text_style.dart';
import 'package:OKRADISH/constants/colors.dart';
import 'package:OKRADISH/constants/sizes.dart';
import 'package:OKRADISH/services/weighing_servce.dart';
import 'package:OKRADISH/widgets/snackbar.dart';

class BluetoothDialog extends StatefulWidget {
  const BluetoothDialog({super.key});

  @override
  State<BluetoothDialog> createState() => _BluetoothDialogState();
}

class _BluetoothDialogState extends State<BluetoothDialog> {
  final WeighingServce ws = Get.find<WeighingServce>();
  @override
  void initState() {
    Get.find<WeighingServce>().scan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        padding: const EdgeInsets.all(Sizes.small),
        child: Obx(
          () => Column(
            children: [
              const Text("لیست دستگاه ها", style: AppTextStyles.textBtn),
              const SizedBox(height: Sizes.medium),
              if (!ws.isSearching.value)
                SizedBox(
                  height: Sizes.smallBtnH,
                  child: IconButton(
                      onPressed: () {
                        ws.scan();
                      },
                      icon: const Icon(Icons.refresh)),
                ),
              Expanded(
                child: ws.isSearching.value
                    ? const Center(child: CircularProgressIndicator())
                    : ws.deviceNames.isEmpty
                        ? const Center(
                            child: Text(
                              "دستگاهی پیدا نشد",
                              style: AppTextStyles.bodyMeduim,
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: ws.deviceNames.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppColors.greyBack,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                                margin: const EdgeInsets.only(bottom:  Sizes.tiny),
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () async {
                                    final res = await ws.connectToDevice(index);
                                    if (!context.mounted) return;
                                    if (res.isEmpty) {
                                      Navigator.of(context).pop();
                                    } else {
                                      showSnackbar(context, res);
                                    }
                                  },
                                  style: AppButtonStyles.textButton,
                                  child: Text(
                                    ws.deviceNames[index].toString(),
                                    style: AppTextStyles.bodyMeduim,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
