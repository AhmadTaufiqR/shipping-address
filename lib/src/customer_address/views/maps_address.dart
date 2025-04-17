import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shipping_address/common/widgets/custom_button.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';
import 'package:shipping_address/src/customer_address/providers/customer_provider.dart';

class MapsAddress extends StatefulWidget {
  const MapsAddress({super.key});

  @override
  _MapsAddressState createState() => _MapsAddressState();
}

class _MapsAddressState extends State<MapsAddress> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(-6.2087634, 106.845599), // Default location (Jakarta)
    zoom: 15,
  );

  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndAddress();
  }

  // Mendapatkan lokasi pengguna saat ini
  Future<void> _getCurrentLocationAndAddress() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Aktifkan layanan lokasi terlebih dahulu")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Izin lokasi ditolak")));
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    var customerP = Provider.of<CustomerProvider>(context, listen: false);
    customerP.lat = position.latitude;
    customerP.long = position.longitude;

    // Mengonversi koordinat ke alamat
    String address = await _getAddressFromLatLng(
      position.latitude,
      position.longitude,
    );

    setState(() {
      // Memperbarui posisi kamera peta
      initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 15,
      );

      // Membersihkan marker sebelumnya dan menambahkan marker baru
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: 'Lokasi Anda'),
          draggable: true, // Izinkan marker untuk dipindah-pindah
          onDragEnd: (newPosition) {
            // Ketika marker dipindahkan
            _updateMarkerAndAddress(newPosition);
          },
        ),
      );

      // Memperbarui alamat di TextEditingController
      _addressController.text = address;
      mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );
    });
  }

  // Mengonversi koordinat ke alamat
  Future<String> _getAddressFromLatLng(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      Placemark place = placemarks[0];
      return "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      return "Gagal mendapatkan alamat";
    }
  }

  // Memperbarui marker dan alamat saat dipindahkan
  Future<void> _updateMarkerAndAddress(LatLng newPosition) async {
    String address = await _getAddressFromLatLng(
      newPosition.latitude,
      newPosition.longitude,
    );

    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: newPosition,
          infoWindow: InfoWindow(title: 'Lokasi Baru'),
          draggable: true,
          onDragEnd: (newPosition) {
            _updateMarkerAndAddress(newPosition);
          },
        ),
      );

      _addressController.text = address; // Perbarui alamat di TextField
      mapController.animateCamera(
        CameraUpdate.newLatLng(newPosition),
      ); // Animasikan kamera
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextField.normalTextField(
          controller: _addressController,
          height: 45,
          contentPadding: true,
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          mapController = controller;
        },
        onTap: (LatLng tappedPosition) {
          // Ketika pengguna mengetuk peta
          _updateMarkerAndAddress(tappedPosition);
        },
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Consumer<CustomerProvider>(
          builder: (context, customerP, _) {
            return CustomButton.normalCustomButton(
              text: 'Pilih Lokasi',
              onTap: () {
                customerP.setSelectedLocation(_addressController.text);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil Menetapkan Alamat'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
