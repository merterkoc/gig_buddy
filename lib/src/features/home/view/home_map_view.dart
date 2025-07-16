import 'package:flutter/material.dart';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gig_buddy/src/bloc/event/event_bloc.dart';
import 'package:gig_buddy/src/service/model/event_detail/event_detail.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';

class HomeMapView extends StatefulWidget {
  const HomeMapView({super.key});

  @override
  State<HomeMapView> createState() => _HomeMapViewState();
}

class _HomeMapViewState extends State<HomeMapView> {
  AppleMapController? _mapController;
  LatLng? _center;

  @override
  void initState() {
    super.initState();
    final pos = LocationManager.position;
    if (pos != null) {
      _center = LatLng(pos.latitude, pos.longitude);
    }
  }

  void _onMapCreated(AppleMapController controller) {
    _mapController = controller;
  }

  void _onCameraIdle() async {
    if (_mapController == null) return;
    final bounds = await _mapController!.getVisibleRegion();
    // Calculate center of bounds
    final centerLat =
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2;
    final centerLng =
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2;
    // Fetch events for the visible region
    context.read<EventBloc>().add(EventLoadByLocation(
          lat: centerLat,
          lng: centerLng,
          limit: 50,
        ));
  }

  Set<Annotation> _buildEventMarkers(List<EventDetail> events) {
    return events
        .map((event) {
          final lat = double.tryParse(event.location!.latitude);
          final lng = double.tryParse(event.location!.longitude);
          if (lat == null || lng == null) return null;
          return Annotation(
            annotationId: AnnotationId(event.id),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: event.name,
              snippet: event.venue?.name,
            ),
          );
        })
        .whereType<Annotation>()
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        final events = state.events ?? [];
        return AppleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target:
                _center ?? const LatLng(41.0082, 28.9784), // İstanbul default
            zoom: 12,
          ),
          annotations: _buildEventMarkers(events),
          onCameraIdle: _onCameraIdle,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        );
      },
    );
  }
}
