import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/branch/presentation/provider/createbranchprovider.dart';

class OfficeLocationScreen extends StatefulWidget {
  const OfficeLocationScreen({super.key});

  @override
  State<OfficeLocationScreen> createState() => _OfficeLocationScreenState();
}

class _OfficeLocationScreenState extends State<OfficeLocationScreen> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;

  LatLng _currentCenter = const LatLng(10.8505, 76.2711); // Kerala default
  String _currentAddress = '';
  bool _isLoadingAddress = false;
  bool _isLoadingLocation = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ── Get device current location ──
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return;

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(pos.latitude, pos.longitude);
      _moveToLocation(latLng);
    } catch (e) {
      debugPrint('Location error: $e');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  // ── Move map to a LatLng and reverse geocode ──
  Future<void> _moveToLocation(LatLng latLng) async {
    setState(() {
      _currentCenter = latLng;
      _isLoadingAddress = true;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(latLng, 16),
    );

    await _reverseGeocode(latLng);
  }

  // ── Reverse geocode ──
  Future<void> _reverseGeocode(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
        ].where((s) => s != null && s.isNotEmpty).toList();
        setState(() {
          _currentAddress = parts.join(', ');
          _searchController.text = parts
              .where((s) => s != p.street)
              .join(', ');
        });
      }
    } catch (e) {
      debugPrint('Geocode error: $e');
    } finally {
      setState(() => _isLoadingAddress = false);
    }
  }

  // ── Search by text ──
  Future<void> _searchPlace(String query) async {
    if (query.trim().isEmpty) return;
    try {
      final locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final l = locations.first;
        _moveToLocation(LatLng(l.latitude, l.longitude));
      }
    } catch (e) {
      debugPrint('Search error: $e');
    }
  }

  // ── Camera moved — update address ──
  void _onCameraIdle() {
    _reverseGeocode(_currentCenter);
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _currentCenter = position.target;
      _isLoadingAddress = true;
    });
  }

  // ── Continue: return selected location ──
  void _onContinue() {
    if (_currentAddress.isEmpty) return;
    final location = SelectedLocation(
      address: _currentAddress,
      latitude: _currentCenter.latitude,
      longitude: _currentCenter.longitude,
    );
    Navigator.pop(context, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Map fills the upper portion ──
            Column(
              children: [
                // App bar
                _buildAppBar(),

                // Search bar
                _buildSearchBar(),

                // Map
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentCenter,
                          zoom: 15,
                        ),
                        onMapCreated: (c) => _mapController = c,
                        onCameraMove: _onCameraMove,
                        onCameraIdle: _onCameraIdle,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapType: MapType.satellite,
                      ),

                      // Center pin
                      Positioned(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF7043),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on,
                                  color: Colors.white, size: 20),
                            ),
                            Container(
                              width: 2,
                              height: 10,
                              color: const Color(0xFFFF7043),
                            ),
                          ],
                        ),
                      ),

                      // My location button
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: _getCurrentLocation,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: _isLoadingLocation
                                ? const Padding(
                                    padding: EdgeInsets.all(10),
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppStyle.accentCyan),
                                  )
                                : const Icon(Icons.navigation_rounded,
                                    color: AppStyle.accentCyan, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Bottom sheet ──
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomSheet(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const Icon(Icons.arrow_back_rounded, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Office Location',
                style: AppStyle.text(size: 18, weight: FontWeight.w700)),
          ),
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFFCDD2)),
              ),
              child: Text('Skip',
                  style: AppStyle.text(
                      size: 13,
                      color: const Color(0xFFE53935),
                      weight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onSubmitted: _searchPlace,
          textInputAction: TextInputAction.search,
          style: AppStyle.text(size: 14),
          decoration: InputDecoration(
            hintText: 'Search location...',
            hintStyle: AppStyle.text(size: 14, color: AppStyle.hintColor),
            prefixIcon:
                const Icon(Icons.search_rounded, color: AppStyle.hintColor),
            suffixIcon: _searchController.text.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Icon(Icons.close_rounded,
                        color: AppStyle.hintColor),
                  )
                : null,
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: (v) {
            setState(() {});
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 600), () {
              _searchPlace(v);
            });
          },
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text('Choose Location',
              style: AppStyle.text(size: 16, weight: FontWeight.w700)),
          const SizedBox(height: 14),

          // Current location row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: AppStyle.accentCyan, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Location',
                        style: AppStyle.text(
                            size: 12, color: AppStyle.accentCyan)),
                    const SizedBox(height: 2),
                    _isLoadingAddress
                        ? const SizedBox(
                            height: 14,
                            width: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppStyle.accentCyan),
                          )
                        : Text(
                            _currentAddress.isNotEmpty
                                ? _currentAddress
                                : 'Move map to select location',
                            style:
                                AppStyle.text(size: 14, weight: FontWeight.w600),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Continue button
          GestureDetector(
            onTap: _onContinue,
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                gradient: AppStyle.primaryGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: Text('Continue',
                  style: AppStyle.text(
                      size: 16, color: Colors.white, weight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}