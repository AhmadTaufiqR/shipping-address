import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shipping_address/common/widgets/custom_textfield.dart';

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

  final TextEditingController _addressController = TextEditingController();

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
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
