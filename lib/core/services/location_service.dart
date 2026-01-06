import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

/// Estado del servicio de localización
class LocationState {
  final bool isLoading;
  final bool hasPermission;
  final Position? currentPosition;
  final String? address;
  final String? zipCode;
  final String? city;
  final String? country;
  final String? error;

  const LocationState({
    this.isLoading = false,
    this.hasPermission = false,
    this.currentPosition,
    this.address,
    this.zipCode,
    this.city,
    this.country,
    this.error,
  });

  LocationState copyWith({
    bool? isLoading,
    bool? hasPermission,
    Position? currentPosition,
    String? address,
    String? zipCode,
    String? city,
    String? country,
    String? error,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      hasPermission: hasPermission ?? this.hasPermission,
      currentPosition: currentPosition ?? this.currentPosition,
      address: address ?? this.address,
      zipCode: zipCode ?? this.zipCode,
      city: city ?? this.city,
      country: country ?? this.country,
      error: error,
    );
  }

  /// Obtiene una descripción corta de la ubicación
  String get shortDescription {
    if (zipCode != null && city != null) {
      return '$zipCode, $city';
    } else if (zipCode != null) {
      return zipCode!;
    } else if (city != null) {
      return city!;
    } else if (address != null) {
      return address!;
    }
    return 'Ubicación desconocida';
  }
}

/// Servicio de geolocalización
class LocationService extends StateNotifier<LocationState> {
  LocationService() : super(const LocationState());

  /// Verifica y solicita permisos de ubicación
  Future<bool> checkAndRequestPermission() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(
          isLoading: false,
          hasPermission: false,
          error: 'Los servicios de ubicación están deshabilitados',
        );
        return false;
      }

      // Verificar permiso
      var status = await Permission.location.status;

      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        state = state.copyWith(
          isLoading: false,
          hasPermission: false,
          error:
              'Permiso de ubicación denegado permanentemente. Por favor, habilítelo en configuración.',
        );
        return false;
      }

      if (!status.isGranted) {
        state = state.copyWith(
          isLoading: false,
          hasPermission: false,
          error: 'Permiso de ubicación no concedido',
        );
        return false;
      }

      state = state.copyWith(
        isLoading: false,
        hasPermission: true,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasPermission: false,
        error: 'Error al verificar permisos: $e',
      );
      return false;
    }
  }

  /// Obtiene la ubicación actual del dispositivo
  Future<Position?> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Verificar permisos primero
      final hasPermission = await checkAndRequestPermission();
      if (!hasPermission) return null;

      // Obtener posición actual
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      state = state.copyWith(
        currentPosition: position,
        isLoading: false,
      );

      // Obtener dirección a partir de coordenadas
      await getAddressFromPosition(position);

      return position;
    } catch (e) {
      String errorMessage;
      if (e is TimeoutException) {
        errorMessage = 'Tiempo de espera agotado al obtener ubicación';
      } else if (e is LocationServiceDisabledException) {
        errorMessage = 'Servicio de ubicación deshabilitado';
      } else {
        errorMessage = 'Error al obtener ubicación: $e';
      }

      state = state.copyWith(
        isLoading: false,
        error: errorMessage,
      );
      return null;
    }
  }

  /// Convierte una posición en dirección legible
  Future<void> getAddressFromPosition(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        // Construir dirección completa
        final addressParts = <String>[];
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        state = state.copyWith(
          address: addressParts.join(', '),
          zipCode: place.postalCode,
          city: place.locality ?? place.subAdministrativeArea,
          country: place.country,
        );
      }
    } catch (e) {
      // No establecer error aquí, ya tenemos la posición
      debugPrint('Error al obtener dirección: $e');
    }
  }

  /// Obtiene la dirección a partir de un código postal
  Future<void> getAddressFromZipCode(String zipCode) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Buscar ubicación por código postal (agregamos país para mejor precisión)
      final locations = await locationFromAddress('$zipCode, USA');

      if (locations.isNotEmpty) {
        final location = locations.first;

        // Obtener detalles de la dirección
        final placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          final place = placemarks.first;

          state = state.copyWith(
            isLoading: false,
            currentPosition: Position(
              latitude: location.latitude,
              longitude: location.longitude,
              timestamp: DateTime.now(),
              accuracy: 0,
              altitude: 0,
              altitudeAccuracy: 0,
              heading: 0,
              headingAccuracy: 0,
              speed: 0,
              speedAccuracy: 0,
            ),
            zipCode: zipCode,
            city: place.locality ?? place.subAdministrativeArea,
            country: place.country,
            address:
                '${place.locality ?? ''}, ${place.administrativeArea ?? ''}',
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'No se encontró ubicación para el código postal',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Código postal inválido o no encontrado',
      );
    }
  }

  /// Calcula la distancia entre dos puntos en kilómetros
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convertir metros a kilómetros
  }

  /// Abre la configuración de ubicación del dispositivo
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Abre la configuración de la aplicación para permisos
  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Limpia el estado
  void clearLocation() {
    state = const LocationState();
  }
}

/// Provider para el servicio de localización
final locationServiceProvider =
    StateNotifierProvider<LocationService, LocationState>((ref) {
  return LocationService();
});

/// Widget de diálogo para selección de ubicación
class LocationPickerDialog extends ConsumerStatefulWidget {
  final String? initialZipCode;
  final Function(String zipCode, String? city) onLocationSelected;

  const LocationPickerDialog({
    super.key,
    this.initialZipCode,
    required this.onLocationSelected,
  });

  @override
  ConsumerState<LocationPickerDialog> createState() =>
      _LocationPickerDialogState();
}

class _LocationPickerDialogState extends ConsumerState<LocationPickerDialog> {
  late TextEditingController _zipController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController(text: widget.initialZipCode);
  }

  @override
  void dispose() {
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationServiceProvider);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Icon(Icons.location_on, color: Colors.deepOrange.shade400),
          const SizedBox(width: 8),
          const Text('Seleccionar ubicación'),
        ],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de código postal
              TextFormField(
                controller: _zipController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                decoration: InputDecoration(
                  labelText: 'Código postal (ZIP)',
                  hintText: 'Ej: 33172',
                  prefixIcon: const Icon(Icons.pin_drop),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese un código postal';
                  }
                  if (value.length != 5) {
                    return 'El código postal debe tener 5 dígitos';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Solo se permiten números';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Botón para usar ubicación GPS
              OutlinedButton.icon(
                onPressed: locationState.isLoading
                    ? null
                    : () async {
                        final locationService =
                            ref.read(locationServiceProvider.notifier);
                        await locationService.getCurrentLocation();

                        final newState = ref.read(locationServiceProvider);
                        if (newState.zipCode != null) {
                          _zipController.text = newState.zipCode!;
                        }
                      },
                icon: locationState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.my_location),
                label: Text(
                  locationState.isLoading
                      ? 'Obteniendo ubicación...'
                      : 'Usar mi ubicación actual',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              // Mostrar error si existe
              if (locationState.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            locationState.error!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Mostrar ubicación detectada
              if (locationState.city != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${locationState.city}, ${locationState.country ?? 'USA'}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: locationState.isLoading
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    widget.onLocationSelected(
                      _zipController.text,
                      locationState.city,
                    );
                    Navigator.of(context).pop();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Aplicar'),
        ),
      ],
    );
  }
}
