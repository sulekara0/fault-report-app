import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Step3Location extends StatefulWidget {
  final String location;
  final Function(String) onLocationChanged;
  final GlobalKey<FormState> formKey;

  const Step3Location({
    super.key,
    required this.location,
    required this.onLocationChanged,
    required this.formKey,
  });

  @override
  State<Step3Location> createState() => _Step3LocationState();
}

class _Step3LocationState extends State<Step3Location> {
  GoogleMapController? _mapController;
  LatLng _selectedLatLng = const LatLng(41.0082, 28.9784); // İstanbul varsayılan
  Set<Marker> _markers = {};
  
  final TextEditingController _addressController = TextEditingController();
  bool _isLoadingLocation = false;
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    if (widget.location.isNotEmpty) {
      _addressController.text = widget.location;
      _geocodeAddress(widget.location);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  // Anlık konumu al ve adres alanını doldur
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Konum izni kontrolü
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.denied || 
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Konum izni gerekli!')),
        );
        return;
      }

      // Anlık konumu al
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium, // Daha düşük hassasiyet
        timeLimit: const Duration(seconds: 10), // Zaman sınırı
      );

      // Koordinatları LatLng'e çevir
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      
      // Koordinatları adrese çevir
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String fullAddress = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((element) => element != null && element.isNotEmpty).join(', ');
        
        // Adres alanını doldur
        _addressController.text = fullAddress;
        widget.onLocationChanged(fullAddress);
      }

      // Haritada göster
      _setMapPosition(currentLocation);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konum alınamadı: $e')),
      );
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  // Adresi koordinata çevir
  Future<void> _geocodeAddress(String address) async {
    if (address.trim().isEmpty) return;
    
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        LatLng location = LatLng(
          locations.first.latitude,
          locations.first.longitude,
        );
        _setMapPosition(location);
      }
    } catch (e) {
      // Hata durumunda sessizce geç
      print('Geocoding hatası: $e');
    }
  }

  // Haritada konumu göster
  void _setMapPosition(LatLng position) {
    setState(() {
      _selectedLatLng = position;
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          infoWindow: const InfoWindow(title: 'Seçilen Konum'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      };
    });
    
    // Harita hazır olduğunda kamera pozisyonunu güncelle
    if (_isMapReady && _mapController != null) {
      try {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );
      } catch (e) {
        print('Harita güncelleme hatası: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Başlık
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Arıza Konumu',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),

                // Adres Giriş Alanı
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.edit_location,
                              color: Colors.blue,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Adres Bilgisi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Adres Giriş Alanı
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: 'Tam Adres',
                            hintText: 'Örn: Kadıköy Mahallesi, İstanbul',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.blue, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            prefixIcon: const Icon(Icons.location_on, color: Colors.blue),
                            suffixIcon: _isLoadingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : IconButton(
                                    icon: const Icon(Icons.my_location, color: Colors.blue),
                                    onPressed: _getCurrentLocation,
                                    tooltip: 'Anlık Konumumu Kullan',
                                  ),
                          ),
                          maxLines: 2,
                          onChanged: (value) {
                            widget.onLocationChanged(value);
                            if (value.length > 10) {
                              _geocodeAddress(value);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Lütfen adres giriniz';
                            }
                            if (value.trim().length < 10) {
                              return 'Adres daha detaylı olmalı';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Anlık Konum Butonu
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                            icon: _isLoadingLocation
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.my_location),
                            label: Text(_isLoadingLocation ? 'Konum Alınıyor...' : 'Anlık Konumumu Kullan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Harita
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          // Harita Başlığı
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.map,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Harita Görünümü',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Harita
                          Expanded(
                            child: GoogleMap(
                              onMapCreated: (controller) {
                                _mapController = controller;
                                setState(() {
                                  _isMapReady = true;
                                });
                                print('Harita başarıyla yüklendi');
                              },
                              initialCameraPosition: CameraPosition(
                                target: _selectedLatLng,
                                zoom: 12, // Daha düşük zoom seviyesi
                              ),
                              markers: _markers,
                              zoomControlsEnabled: false,
                              myLocationEnabled: false, // Performans için kapalı
                              myLocationButtonEnabled: false,
                              mapToolbarEnabled: false,
                              liteModeEnabled: false,
                              compassEnabled: false,
                              trafficEnabled: false,
                              buildingsEnabled: false, // Bina detayları kapalı
                              indoorViewEnabled: false, // İç mekan görünümü kapalı
                              tiltGesturesEnabled: false, // Eğim hareketleri kapalı
                              rotateGesturesEnabled: false, // Döndürme hareketleri kapalı
                              scrollGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              mapType: MapType.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
