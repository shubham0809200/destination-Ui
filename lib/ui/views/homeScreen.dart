import 'dart:convert';

import 'package:dev_test/res/timeData.dart';
import 'package:dev_test/res/url.dart';
import 'package:dev_test/ui/widgets/clipBox.dart';
import 'package:dev_test/ui/widgets/customSnackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _amActive = true;
  bool _pmActive = false;

  // loading
  bool _isLoading = false;

  // six items with false value
  bool _item1 = false;
  bool _item2 = false;
  bool _item3 = false;
  bool _item4 = false;
  bool _item5 = false;
  bool _item6 = false;

  String start = "N.A.";
  String till = "N.A.";

  final TextEditingController destination = TextEditingController();

  String _time1 = '00:00';
  String _time2 = '00:00';

  _amActivator() {
    setState(() {
      _amActive = !_amActive;
      _pmActive = false;
    });
  }

  _pmActivator() {
    setState(() {
      _pmActive = !_pmActive;
      _amActive = false;
    });
  }

  Future<void> insertrecord() async {
    print("I am inside insertrecord");

    if (destination.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackbarMessage('Please fill All Fields'));
      setState(() {
        _isLoading = false;
      });
    } else {
      try {
        var response = await http.post(Uri.parse(uri), body: {
          "destination": destination.text,
          "start": start,
          "till": till,
        });
        var data = jsonDecode(response.body);

        if (data['success'] == "true") {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackbarMessage('Record Inserted Successfully'));
          setState(() {
            _isLoading = false;
            clearData();
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackbarMessage('Record Insertion Failed'));
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackbarMessage('Error: $e'));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              appBar(context),
              const SizedBox(height: 20),
              tabMenu(),
              const SizedBox(height: 30),
              headingBold('Details'),
              const SizedBox(height: 10),
              Row(children: [
                Column(children: [
                  fromPlace(context),
                  const SizedBox(height: 20),
                  toDestination(context),
                ]),
                // show image
                Container(
                  height: 120,
                  width: 50,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/image/coo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 50),
              headingBold('Pick up'),
              const SizedBox(height: 30),
              timeSelection(),
              const SizedBox(height: 30),
              headingBold('Item Information'),
              const SizedBox(height: 30),
              itemInfo(context),
              const SizedBox(height: 30),
              showTotal(),
              const SizedBox(height: 30),
              submitButton(),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  static Widget appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 2,
              color: Colors.black,
            ),
            const SizedBox(height: 3),
            Container(
              width: 20,
              height: 2,
              color: Colors.black,
              // round shape
            ),
          ],
        ),
        Row(
          children: [
            // create clipboard icon
            InkWell(
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(snackbarMessage('Clipboard Pressed')),
              child: buildBox(),
            ),

            const SizedBox(width: 20),
            // notification bar
            InkWell(
                onTap: (() => ScaffoldMessenger.of(context)
                    .showSnackBar(snackbarMessage("Notification pressed"))),
                child: const Icon(Icons.notifications)),
          ],
        )
      ],
    );
  }

  static Widget tabMenu() {
    return Row(
      children: [
        // creta blue color button
        Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 26, 115, 218),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Text(
              'Send',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        // ontap show grey backgound button with no color
        const SizedBox(width: 20),
        InkWell(
          onTap: () {},
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'Fetch me',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget headingBold(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  static Widget fromPlace(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.69,
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.location_on_rounded,
                    color: Colors.green, size: 35),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('655 Linyin Ave',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text('Jeehome',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget toDestination(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.69,
      height: 78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.flag, color: Colors.red, size: 35),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.49,
                child: TextField(
                  controller: destination,
                  decoration: const InputDecoration(
                    hintText: 'Enter your Destination',
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget timeSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Time",
            style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
        const SizedBox(width: 40),

        Container(
          width: 100,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  _amActivator();
                },
                child: Container(
                  width: 49,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _amActive
                        ? Color.fromARGB(255, 26, 115, 218)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: _amActive
                          ? Color.fromARGB(255, 26, 115, 218)
                          : Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'AM',
                      style: TextStyle(
                          color: _amActive ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _pmActivator();
                },
                child: Container(
                  width: 49,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _pmActive
                        ? Color.fromARGB(255, 26, 115, 218)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        color: _pmActive
                            ? Color.fromARGB(255, 26, 115, 218)
                            : Colors.white),
                  ),
                  child: Center(
                    child: Text(
                      'PM',
                      style: TextStyle(
                          color: _pmActive ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        // create a time scrol selecteor from : to  11:00 - 12:00
        Container(
          width: 135,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () => showPicker(context, "_time1"),
                child: Text(
                  _time1,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const Text(
                '-',
                style: TextStyle(color: Colors.black),
              ),
              InkWell(
                onTap: () => showPicker(context, "_time2"),
                child: Text(
                  _time2,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget itemInfo(BuildContext context) {
    // grid view to show 6 smalllBox()
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item1 = !_item1;
                      });
                    }),
                    child: smallBox(_item1, 'Daily nessacities')),
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item2 = !_item2;
                      });
                    }),
                    child: smallBox(_item2, 'Food')),
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item3 = !_item3;
                      });
                    }),
                    child: smallBox(_item3, 'Documents')),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item4 = !_item4;
                      });
                    }),
                    child: smallBox(_item4, 'Clothing')),
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item5 = !_item5;
                      });
                    }),
                    child: smallBox(_item5, 'Digital Product')),
                InkWell(
                    onTap: (() {
                      setState(() {
                        _item6 = !_item6;
                      });
                    }),
                    child: smallBox(_item6, 'Other')),
              ],
            ),
          ],
        ));
  }

  smallBox(bool active, String text) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: MediaQuery.of(context).size.width * 0.26,
      height: 30,
      decoration: BoxDecoration(
        color: active ? Color.fromARGB(255, 26, 115, 218) : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: active ? Colors.white : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  static Widget showTotal() {
    // total  $48.5
    return Container(
      padding: const EdgeInsets.only(right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tatal price',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Text(
            '\$48,80',
            style: TextStyle(
                color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget submitButton() {
    return Center(
      child: InkWell(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() {
            _isLoading = true;
          });
          insertrecord();
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 26, 115, 218),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  showPicker(BuildContext context, String time) async {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: timeData),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Color.fromARGB(255, 26, 115, 218)),
        selectedTextStyle: const TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        });

    picker.showModal(context).then((value) {
      if (time == "_time1") {
        setState(() {
          _time1 = picker.getSelectedValues()[0];
          // set _time1 with if _amActive or _pmActive
          start = _amActive ? "$_time1 AM" : "$_time1 PM";
          FocusScope.of(context).unfocus();
        });
      } else {
        setState(() {
          _time2 = picker.getSelectedValues()[0];
          till = _pmActive ? "$_time2 AM" : "$_time2 PM";
          FocusScope.of(context).unfocus();
        });
      }
    });
  }

  void clearData() {
    setState(() {
      destination.text = '';
      _time1 = '00:00';
      _time2 = '00:00';
      _item1 = false;
      _item2 = false;
      _item3 = false;
      _item4 = false;
      _item5 = false;
      _item6 = false;
      _amActive = true;
      _pmActive = false;
      _isLoading = false;
    });
  }
}
