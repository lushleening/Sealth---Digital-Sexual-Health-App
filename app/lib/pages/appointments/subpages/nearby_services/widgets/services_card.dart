import 'package:flutter/material.dart';
import 'package:sddp_dsh/helper/colors.dart';

class NearbyService {
  final String name;
  final String address;
  final String hours;
  final double rating;
  final double distanceKm;
  final List<String> tags;

  const NearbyService({
    required this.name,
    required this.address,
    required this.hours,
    required this.rating,
    required this.distanceKm,
    required this.tags,
  });
}

final dummyServices = [
  NearbyService(
    name: 'Downtown Health Center',
    address: '123 Health St, Suite 200',
    hours: 'Open until 8 PM',
    rating: 4.8,
    distanceKm: 0.5,
    tags: ['STI Testing', 'Contraception'],
  ),
  NearbyService(
    name: 'Westside Clinic',
    address: '456 Care Ave, Floor 3',
    hours: 'Open until 9 PM',
    rating: 4.6,
    distanceKm: 1.2,
    tags: ['STI Testing', 'PrEP'],
  ),
  NearbyService(
    name: 'Strt Avenue Clinic',
    address: '46 Care Ave, Suite 458',
    hours: 'Open until 6 PM',
    rating: 4.6,
    distanceKm: 1.7,
    tags: ['Consultation', 'PrEP'],
  ),
];

class NearbyServicesBody extends StatefulWidget {
  final List<NearbyService> services;

  const NearbyServicesBody({super.key, required this.services});

  @override
  State<NearbyServicesBody> createState() => _NearbyServicesBodyState();
}

class _NearbyServicesBodyState extends State<NearbyServicesBody> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Column(
      children: [
        // Search bar
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter location or zip code',
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

        ...widget.services.map((service) => _ServiceCard(service: service)),
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
              Text(
                service.name,
                style: TextStyle(
                  color: c.textPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    service.rating.toString(),
                    style: TextStyle(
                      color: c.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${service.distanceKm} km',
                    style: TextStyle(color: c.textSecondary, fontSize: 13),
                  ),
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
              Text(
                service.address,
                style: TextStyle(color: c.textSecondary, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                service.hours,
                style: const TextStyle(color: Colors.green, fontSize: 13),
              ),
            ],
          ),

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

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
