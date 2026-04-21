import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';
import 'package:url_launcher/url_launcher.dart';

class NearbyService {
  final String clinicId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String? hours;
  final double? rating;
  final double? distanceKm;
  final List<String> tags;

  const NearbyService({
    required this.clinicId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.hours,
    this.rating,
    this.distanceKm,
    this.tags = const [],
  });

  factory NearbyService.fromMap(Map<String, dynamic> map) {
    return NearbyService(
      clinicId: map['id'].toString(),
      name: map['name']?.toString() ?? '',
      address: map['address']?.toString() ?? '',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (map['distance_km'] as num?)?.toDouble(),
    );
  }
}

class NearbyServicesBody extends ConsumerStatefulWidget {
  final List<NearbyService> services;

  const NearbyServicesBody({super.key, required this.services});

  @override
  ConsumerState<NearbyServicesBody> createState() => _NearbyServicesBodyState();
}

class _NearbyServicesBodyState extends ConsumerState<NearbyServicesBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final filtered = widget.services.where((s) {
      if (_searchQuery.isEmpty) return true;
      return s.name.toLowerCase().contains(_searchQuery) ||
          s.address.toLowerCase().contains(_searchQuery);
    }).toList();

    return Column(
      children: [
        TextField(
          controller: _searchController,
          cursorColor: context.colors.mainColor,
          decoration: InputDecoration(
            hintText: 'Search by name or address',
            hintStyle: TextStyle(color: c.textSecondary, fontSize: 14),
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
        ),

        const SizedBox(height: 16),

        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No clinics found.',
              style: TextStyle(color: c.textSecondary, fontSize: 14),
            ),
          )
        else
          ...filtered.map((service) => _ServiceCard(service: service)),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final NearbyService service;

  const _ServiceCard({required this.service});

  void _openInMaps(BuildContext context) async {
  // Build search query using clinic name and address
  String searchQuery;
  if (service.address.isNotEmpty && service.address != 'Location available on map') {
    searchQuery = Uri.encodeComponent('${service.name}, ${service.address}');
  } else {
    searchQuery = Uri.encodeComponent(service.name);
  }
  
  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$searchQuery');
  
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open maps')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: c.whiteBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: c.boxShadowGray,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service.name,
                  style: TextStyle(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (service.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(
                      service.rating!.toString(),
                      style: TextStyle(
                        color: c.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    if (service.distanceKm != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '${service.distanceKm} km',
                        style: TextStyle(color: c.textSecondary, fontSize: 13),
                      ),
                    ],
                  ],
                ),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: c.textSecondary,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  service.address.isNotEmpty ? service.address : 'Location available on map',
                  
                  style: TextStyle(color: c.textSecondary, fontSize: 13),
                ),
              ),
            ],
          ),

                    // Map preview or view on map button
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _openInMaps(context),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: c.boxShadowGray),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Static map preview using OpenStreetMap static image
                    // Replace the Image.network with this
                    Image.network(
                      'https://staticmap.openstreetmap.de/staticmap.php?center=${service.latitude},${service.longitude}&zoom=15&size=400x150&maptype=mapnik&markers=${service.latitude},${service.longitude},red-pushpin',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: c.grayBackground,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.map, size: 30, color: c.mainColor),
                              const SizedBox(height: 4),
                              Text(
                                service.address.isNotEmpty ? service.address : service.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: c.textSecondary, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Overlay gradient for better text visibility
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                    // "Open Maps" button at bottom
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: c.mainColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Navigate',
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (service.hours != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.green),
                const SizedBox(width: 6),
                Text(
                  service.hours!,
                  style: const TextStyle(color: Colors.green, fontSize: 13),
                ),
              ],
            ),
          ],

          if (service.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              children: service.tags
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: c.grayBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: c.boxShadowGray.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(color: c.textSecondary, fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: KBtn.scheduleAppointment.key,
              onPressed: () =>
                  context.push(AppRoute.addEvent, extra: service.clinicId),
              style: ElevatedButton.styleFrom(
                backgroundColor: c.mainColor,
                foregroundColor: c.textWhite,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
              ),
              child: const Text(
                'Schedule Appointment',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
