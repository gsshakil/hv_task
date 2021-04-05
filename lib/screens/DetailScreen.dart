import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DetailScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DetailScreen({Key key, this.device}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text(widget.device.name == null || widget.device.name.isEmpty
            ? 'Unknown Device'
            : widget.device.name),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .75,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  child: Builder(
                    builder: (context) {
                      switch (widget.device.type) {
                        case BluetoothDeviceType.unknown:
                          {
                            return Icon(
                              Icons.bluetooth,
                              size: 150,
                              color: Colors.grey,
                            );
                          }
                          break;
                        case BluetoothDeviceType.dual:
                          {
                            return Icon(
                              Icons.tv,
                              size: 150,
                              color: Colors.grey,
                            );
                          }
                          break;
                        case BluetoothDeviceType.le:
                          {
                            return Icon(
                              Icons.blur_circular_rounded,
                              size: 150,
                              color: Colors.grey,
                            );
                          }
                          break;
                        case BluetoothDeviceType.classic:
                          {
                            return Icon(
                              Icons.bluetooth_outlined,
                              size: 150,
                              color: Colors.grey,
                            );
                          }
                          break;
                        default:
                          {
                            return Icon(
                              Icons.tv,
                              size: 150,
                              color: Colors.grey,
                            );
                          }
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DEVICE NAME:',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                        widget.device.name == null || widget.device.name.isEmpty
                            ? 'Unknown Device'
                            : widget.device.name,
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('MAC ADDRESS:',
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Text(widget.device.id.toString(),
                          style: Theme.of(context).textTheme.bodyText1),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('DEVICE TYPE:',
                        style: Theme.of(context).textTheme.bodyText1),
                    SizedBox(
                      width: 20,
                    ),
                    Builder(
                      builder: (context) {
                        switch (widget.device.type) {
                          case BluetoothDeviceType.unknown:
                            {
                              return Text('Unknown',
                                  style: Theme.of(context).textTheme.bodyText1);
                            }
                            break;
                          case BluetoothDeviceType.dual:
                            {
                              return Text('Dual',
                                  style: Theme.of(context).textTheme.bodyText1);
                            }
                            break;
                          case BluetoothDeviceType.le:
                            {
                              return Text('LE',
                                  style: Theme.of(context).textTheme.bodyText1);
                            }
                            break;
                          case BluetoothDeviceType.classic:
                            {
                              return Text('Classic',
                                  style: Theme.of(context).textTheme.bodyText1);
                            }
                            break;
                          default:
                            {
                              return Text('Unknown',
                                  style: Theme.of(context).textTheme.bodyText1);
                            }
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_isLoading) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await widget.device.connect();
                    } catch (e) {
                      if (e.code != 'already_connected') {
                        throw e;
                      }
                    } finally {}

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Container(
                      width: 150,
                      height: 40,
                      child: Center(
                          child: _isLoading
                              ? const SpinKitThreeBounce(
                                  color: Colors.white30,
                                  size: 20,
                                  duration: Duration(milliseconds: 1000),
                                )
                              : Text('Connect'))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
