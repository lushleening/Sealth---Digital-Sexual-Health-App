import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sddp_dsh/backend/colors/colors/colors.dart';
import 'package:sddp_dsh/backend/constants/routes.dart';
import 'package:sddp_dsh/backend/testing/key_enum.dart';

class NearbyService {
  final String clinicId;
  final String name;
  final String address;
  final String? hours;
  final double? rating;
  final double? distanceKm;
  final List<String> tags;

  const NearbyService({
    required this.clinicId,
    required this.name,
    required this.address,
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
                  service.address,
                  style: TextStyle(color: c.textSecondary, fontSize: 13),
                ),
              ),
            ],
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
