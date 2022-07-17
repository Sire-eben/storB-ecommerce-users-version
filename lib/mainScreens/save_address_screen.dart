import 'package:breejstores_users_app/Global/global.dart';
import 'package:breejstores_users_app/Models/address.dart';
import 'package:breejstores_users_app/constants/constants.dart';
import 'package:breejstores_users_app/widgets/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<Placemark>? placemarks;
  Position? position;

  SaveAddressScreen({Key? key}) : super(key: key);

  Future<Position?> getUserLocationAddress() async {
    await Geolocator.requestPermission();

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placemarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placemarks![0];

    String fullAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    _locationController.text = fullAddress;

    _flatNumber.text =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text =
        '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text = '${pMark.country}';
    _completeAddress.text = fullAddress;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          )),
        ),
        title: const Text(
          "breejStores",
          style: TextStyle(fontSize: 35, fontFamily: "Signatra"),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Align(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Save New Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.person_pin_circle,
                size: 30,
                color: Colors.cyan,
              ),
              title: SizedBox(
                width: 250,
                child: TextField(
                  controller: _locationController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Enter address",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton.icon(
              onPressed: () {
                getUserLocationAddress();
              },
              icon: const Icon(Icons.location_on),
              label: const Text("Get my current location"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: const BorderSide(color: Colors.cyan)))),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  MyTextField(
                    hint: "Name",
                    controller: _name,
                  ),
                  MyTextField(
                    hint: "Phone Number",
                    controller: _phoneNumber,
                  ),
                  MyTextField(
                    hint: "City",
                    controller: _city,
                  ),
                  MyTextField(
                    hint: "State/Country",
                    controller: _state,
                  ),
                  MyTextField(
                    hint: "Address Line",
                    controller: _flatNumber,
                  ),
                  MyTextField(
                    hint: "Complete Address",
                    controller: _completeAddress,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(kDefaultPadding),
              height: 50,
                width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.cyan),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22)))),
                  onPressed: () {
                    //SAVE INFO TO DATABASE
                    if (formKey.currentState!.validate()) {
                      final model = Address(
                              name: _name.text.trim(),
                              phoneNumber: _phoneNumber.text.trim(),
                              flatNumber: _flatNumber.text.trim(),
                              state: _state.text.trim(),
                              fullAddress: _completeAddress.text.trim(),
                              city: _city.text.trim(),
                              lat: position!.latitude,
                              long: position!.longitude)
                          .toJson();

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(sharedPreferences!.getString("uid"))
                          .collection("userAddress")
                          .doc(DateTime.now().millisecondsSinceEpoch.toString())
                          .set(model)
                          .then((value) {
                        Fluttertoast.showToast(
                            msg: "Address has saved successfully!");
                        formKey.currentState!.reset();
                        Navigator.pop(context);
                      });
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Save Address")),
            )
          ],
        ),
      ),
    );
  }
}
