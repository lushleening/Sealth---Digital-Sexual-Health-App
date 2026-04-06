import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/appointments/appointment_provider.dart';
import 'package:sddp_dsh/frontend/common_widgets/async_page.dart';
import 'package:sddp_dsh/frontend/pages/appointments/subpages/nearby_services/widgets/services_card.dart';

class NearbyServicesPage extends ConsumerStatefulWidget {
  const NearbyServicesPage({super.key});

  @override
  ConsumerState<NearbyServicesPage> createState() => _NearbyServicesPageState();
}

class _NearbyServicesPageState extends ConsumerState<NearbyServicesPage> {
  final TextEditingController _postcodeController = TextEditingController();
  double? _lat;
  double? _lng;
  bool _isLocating = false;
  String? _locationError;
  static const double _radiusKm = 10;

  @override
  void dispose() {
    _postcodeController.dispose();
    super.dispose();
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _isLocating = true;
      _locationError = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permission denied';
          _isLocating = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _isLocating = false;
      });
    } catch (e) {
      setState(() {
        _locationError = 'Could not get location';
        _isLocating = false;
      });
    }
  }

  Future<void> _searchByPostcode() async {
    final postcode = _postcodeController.text.trim();
    if (postcode.isEmpty) return;

    setState(() {
      _isLocating = true;
      _locationError = null;
    });

    final coords = await geocodePostcode(postcode);
    if (coords == null) {
      setState(() {
        _locationError = 'Postcode not found';
        _isLocating = false;
      });
      return;
    }

    setState(() {
      _lat = coords['lat'];
      _lng = coords['lng'];
      _isLocating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      backgroundColor: c.grayBackground,
      appBar: AppBar(
        title: const Text("Nearby Services"),
        backgroundColor: c.mainColor,
        foregroundColor: c.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // --- Postcode search ---
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postcodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter postcode (e.g. 50450)',
                      hintStyle: TextStyle(
                        color: c.textSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search, color: c.textSecondary),
                      filled: true,
                      fillColor: c.whiteBackground,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: c.boxShadowGray),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: c.boxShadowGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: c.mainColor, width: 1.5),
                      ),
                    ),
                    onSubmitted: (_) => _searchByPostcode(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _searchByPostcode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.mainColor,
                    foregroundColor: c.textWhite,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- Use my location button ---
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _isLocating ? null : _useMyLocation,
                icon: _isLocating
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: LoadingCircleMainColor(),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  _isLocating ? 'Getting location...' : 'Use my location',
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.mainColor,
                  side: BorderSide(color: c.mainColor),
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            if (_locationError != null) ...[
              const SizedBox(height: 8),
              Text(
                _locationError!,
                style: TextStyle(color: c.alert, fontSize: 13),
              ),
            ],

            const SizedBox(height: 20),

            // --- Results ---
            if (_lat == null || _lng == null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: c.mainColoredBox,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Enter a postcode or use your location\nto find clinics near you.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: c.textSecondary, fontSize: 14),
                  ),
                ),
              )
            else
              _ClinicResults(lat: _lat!, lng: _lng!, radiusKm: _radiusKm),
          ],
        ),
      ),
    );
  }
}

class _ClinicResults extends ConsumerWidget {
  final double lat;
  final double lng;
  final double radiusKm;

  const _ClinicResults({
    required this.lat,
    required this.lng,
    required this.radiusKm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.colors;
    final nearbyClinicsAsync = ref.watch(
      nearbyClinicsProvider((lat: lat, lng: lng, radiusKm: radiusKm)),
    );

    return nearbyClinicsAsync.when(
      loading: () =>
          Center(child: CircularProgressIndicator(color: c.mainColor)),
      error: (e, _) => Text('Error: $e', style: TextStyle(color: c.alert)),
      data: (clinics) {
        if (clinics.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: c.mainColoredBox,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'No clinics found within ${radiusKm.toInt()} km.',
                style: TextStyle(color: c.textSecondary, fontSize: 14),
              ),
            ),
          );
        }

        final services = clinics.map((c) => NearbyService.fromMap(c)).toList();

        return NearbyServicesBody(
          key: const ValueKey('nearby_results'),
          services: services,
        );
      },
    );
  }
}
