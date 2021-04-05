import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:hvble_task/screens/DetailScreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  final List<BluetoothDevice> devicesList = [];

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isScaning;
  @override
  void initState() {
    super.initState();
    widget.flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        _addDeviceTolist(device);
      }
    });
    widget.flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    widget.flutterBlue.startScan();
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (!widget.devicesList.contains(device)) {
      setState(() {
        widget.devicesList.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: Text(
              'HYPERVOLT EV',
            ),
            backgroundColor: Colors.black87,
            centerTitle: true,
            floating: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'AVAILABLE DEVICES',
                style: TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          _buildListViewOfDevices(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        child: StreamBuilder(
          stream: widget.flutterBlue.isScanning,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data) {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  _isScaning = true;
                });
              });

              return Stack(
                alignment: Alignment.center,
                children: [
                  const SpinKitDoubleBounce(
                    color: Colors.black12,
                    size: 100,
                    duration: Duration(milliseconds: 4000),
                  ),
                  Icon(Icons.bluetooth_searching_rounded)
                ],
              );
            } else {
              Future.delayed(Duration.zero, () async {
                setState(() {
                  _isScaning = false;
                });
              });
              return Stack(
                children: [Icon(Icons.play_arrow)],
              );
            }
          },
        ),
        onPressed: () {
          _isScaning
              ? widget.flutterBlue.stopScan()
              : widget.flutterBlue.startScan();
        },
      ),
    );
  }

  SliverList _buildListViewOfDevices() {
    List<Container> containers = [];
    for (BluetoothDevice device in widget.devicesList) {
      containers.add(Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Card(
            elevation: 5,
            child: ListTile(
              title: Text(device.name == null || device.name.isEmpty
                  ? '[Unknown Device]'
                  : device.name),
              subtitle: Text(
                  device.id == null ? 'NO MAC ID FOUND' : device.id.toString()),
              leading: Builder(
                builder: (context) {
                  switch (device.type) {
                    case BluetoothDeviceType.unknown:
                      {
                        return Icon(
                          Icons.bluetooth,
                        );
                      }
                      break;
                    case BluetoothDeviceType.dual:
                      {
                        return Icon(
                          Icons.tv,
                        );
                      }
                      break;
                    case BluetoothDeviceType.le:
                      {
                        return Icon(
                          Icons.blur_circular_rounded,
                        );
                      }
                      break;
                    case BluetoothDeviceType.classic:
                      {
                        return Icon(
                          Icons.bluetooth_outlined,
                        );
                      }
                      break;
                    default:
                      {
                        return Icon(
                          Icons.tv,
                        );
                      }
                  }
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            device: device,
                          )),
                ).then((value) => setState(() {}));
              },
            ),
          )));
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        ...containers,
      ]),
    );
  }
}
