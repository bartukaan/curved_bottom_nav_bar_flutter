import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:hex/hex.dart';

class BluetoothClassicMainScreen extends StatefulWidget {
  final BluetoothDevice device;

  const BluetoothClassicMainScreen({this.device});

  @override
  _BluetoothClassicScreen createState() => new _BluetoothClassicScreen();
}

class _BluetoothClassicScreen extends State<BluetoothClassicMainScreen> {
  Timer _timer;

  startTimeout([int milliseconds]) {
    return _timer = Timer.periodic(new Duration(seconds: 2), (timer) {
     // handleTimeout();
    });
  }

  ScrollController _scrollController = new ScrollController();
 // List<Sayac> sayacList = new List<Sayac>();
  int _selectedIndex = 0;
  final _selectedSayacNo = TextEditingController();
  int uzunluk = 0;
  List<int> tempData = new List<int>();

  BluetoothConnection connection;

  bool isConnecting = true;
  bool _isShowAnimation = false;
  String _isShowAnimationFileName = "";

  bool get isConnected => connection != null && connection.isConnected;
  bool isDisconnecting = false;

  @override
  void initState() {
    if (this.mounted) {
      //lottieHidingAnimationNoTimer("assets/animations/luna.json");
      BluetoothConnection.toAddress(widget.device.address).then((_connection) {
        connection = _connection;
        connectedDeviceService().then((data) {
          /*   NotificationService.getFlushBar("Modem ayarları yapılıyor ⚙️", "Modem ayarları gönderilidi ✔ ", context);
          _sendMessage(KomutService.rfModeSet());*/
        });
        setState(() {
          isConnecting = false;
          isDisconnecting = false;
        });
      }).catchError((error) {
        print('Cannot connect, exception occurred' + error);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    _timer.cancel();
    super.dispose();
  }


  _BluetoothClassicScreen() {
    //  startTimeout();
  }

  @override
  Widget build(BuildContext context) {
/*    Timer(
      Duration(seconds: 1),
      () =>
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent),
    );*/
    return Scaffold(
      appBar: AppBar(title:   isConnected
          ? _appBarBluetoothConnected()
            : _appBarBluetoothDisconnected(),),
      backgroundColor: Colors.orangeAccent,
      body: Center(child: Column(children: [
        Text("Connected Device Name: "+ widget.device.name),
        Text("Connected Device MAC: "+widget.device.address),

      ],),),
    );
  }

  Future<bool> connectedDeviceService() async {
    print('Connected to the device');
    connection.input.listen(_onDataReceived).onDone(() {
      // Example: Detect which side closed the connection
      // There should be `isDisconnecting` flag to show are we are (locally)
      // in middle of disconnecting process, should be set before calling
      // `dispose`, `finish` or `close`, which all causes to disconnect.
      // If we except the disconnection, `onDone` should be fired as result.
      // If we didn't except this (no flag set), it means closing by remote.
      if (isDisconnecting) {
        print('Disconnecting locally!');
      } else {
        print('Disconnected remotely!');
      }
      if (this.mounted) {
        setState(() {});
      }
    });
    return true;
  }


  void meterFiltered(String sayacNo) {
    setState(() {
      this._selectedIndex = 1;
      //sayacList = sayacList.where((element) => element.sayacNo == sayacNo).toList();
    });
  }


  void exitMethod() {
    connection.dispose();
    Navigator.pop(context);
  }

/*
  void handleTimeout() {
    if (tempData.length != 0) {
      if (uzunluk == tempData.length) {
        List<int> newTempData = [...tempData];
        tempData.clear();
        uzunluk = 0;
        parseMethod(newTempData);
      } else {
        uzunluk = tempData.length;
      }
    }
  }
*/

  void parseMethod(List<int> tempData) {
    var hexData = HEX.encode(tempData);
    /*   var result = ParserService.parserStart(hexData);
    if (result != null) {
      if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.rEADOUTS_OKU_ALL]) {
        setState(() {
          _isShowAnimation = false;
          sayacList.clear();
          sayacList = ParserService.readOutOkuParser(hexData);
          NotificationService.getFlushBar("Sayaç listesi yeniledi ✔️ ", sayacList.length.toString() + " sayaç bulundu ⏬", context);
        });
      } else if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.mK_RF_MODE]) {
        NotificationService.getFlushBar("Modem tarihi ve saati güncelleniyor ⏰ ",
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()).toString() + " olarak gönderildi ✔", context);
        _sendMessage(KomutService.clockSet());
      } else if (result == CalisacakFonksiyonGetir[CalisacakFonksiyon.mK_TIME_UPDATE]) {
        setState(() {
          _sendMessage(KomutService.readOutAll());
        });
      }
    }*/
  }

  void _onDataReceived(Uint8List data) {
    print(data.toString());
    for (var i = 0; i < data.length; i++) {
      tempData.add(data[i]);
    }
    print("DATA=>" + data.toString());
  }

  void _sendMessage(List<int> commandList) async {
    String command = "";
    for (int i = 0; i < commandList.length; i++) {
      command += commandList[i].toRadixString(16).padLeft(2, '0').toUpperCase();
    }

    try {
      connection.output
          .add(HEX.decode(command)); // ("3,4,5,0") ==>  O3 04 05 00

      print("Gönderilen : " +
          command +
          " HEX " +
          (HEX.decode(command).toString()));

      await connection.output.allSent;
    } catch (e) {
      print("Error: " + e);
    }
  }

  lottieHidingAnimation(String fileName) {
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isShowAnimation = false;
        _isShowAnimationFileName = "";
      });
    });
    setState(() {
      _isShowAnimation = true;
      _isShowAnimationFileName = fileName;
    });
  }
  _appBarBluetoothConnected() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /* IconButton(
              icon: Icon(
                Icons.bluetooth_disabled_outlined,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => _disconnectBluetoothDevice(),
              tooltip: "Disconnect",
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("BC Connected", style: TextStyle(fontSize: 15)),
                Text(widget.device.name, style: TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _appBarBluetoothDisconnected() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /* IconButton(
              icon: Icon(
                Icons.bluetooth_connected,
                color: Colors.white,
                size: 35,
              ),
              onPressed: () => _reconnectLastBluetoothDevice(),
              tooltip: "Connect",
            ),*/
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("BC Disconnected", style: TextStyle(fontSize: 15)),
                //  Text(widget.device.name, style: TextStyle(fontSize: 13)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  lottieHidingAnimationNoTimer(String fileName) {
    setState(() {
      _isShowAnimation = true;
      _isShowAnimationFileName = fileName;
    });
  }

}
