import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/agent_crm_models.dart';

/// Servicio para interactuar con Agent CRM Pro (Go High Level) REST API
/// Maneja contactos, cursos/productos, oportunidades, calendarios, etc.
class AgentCRMService {
  final Dio _dio;
  final String _locationId;

  static AgentCRMService? _instance;

  AgentCRMService._({
    required String apiKey,
    required String locationId,
    required String baseUrl,
    required String apiVersion,
  })  : _locationId = locationId,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Version': apiVersion,
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ));

  /// Singleton instance
  static AgentCRMService get instance {
    _instance ??= AgentCRMService._(
      apiKey: dotenv.env['AGENT_CRM_API_KEY'] ?? '',
      locationId: dotenv.env['AGENT_CRM_LOCATION_ID'] ?? '',
      baseUrl: dotenv.env['AGENT_CRM_BASE_URL'] ??
          'https://services.leadconnectorhq.com',
      apiVersion: dotenv.env['AGENT_CRM_API_VERSION'] ?? '2021-07-28',
    );
    return _instance!;
  }

  /// Location ID
  String get locationId => _locationId;

  // ==================== Location ====================

  /// Obtiene información de la ubicación/empresa
  Future<AgentCRMLocation?> getLocation() async {
    try {
      final response = await _dio.get('/locations/$_locationId');
      if (response.data != null) {
        return AgentCRMLocation.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _handleError('getLocation', e);
      return null;
    }
  }

  // ==================== Products/Courses ====================

  /// Obtiene todos los productos/cursos
  Future<List<AgentCRMProduct>> getProducts({
    int limit = 100,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/products/',
        queryParameters: {
          'locationId': _locationId,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.data != null && response.data['products'] != null) {
        return (response.data['products'] as List)
            .map((json) => AgentCRMProduct.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getProducts', e);
      return [];
    }
  }

  /// Obtiene un producto por ID
  Future<AgentCRMProduct?> getProductById(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');
      if (response.data != null) {
        return AgentCRMProduct.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _handleError('getProductById', e);
      return null;
    }
  }

  /// Obtiene solo los cursos (filtra por nombre o tipo)
  Future<List<AgentCRMProduct>> getCourses() async {
    final products = await getProducts();
    return products.where((p) => p.isCourse && !p.isMembership).toList();
  }

  /// Obtiene solo las membresías
  Future<List<AgentCRMProduct>> getMemberships() async {
    final products = await getProducts();
    return products.where((p) => p.isMembership).toList();
  }

  // ==================== Contacts ====================

  /// Obtiene lista de contactos
  Future<List<AgentCRMContact>> getContacts({
    int limit = 100,
    int skip = 0,
    String? query,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'locationId': _locationId,
        'limit': limit,
        'skip': skip,
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      final response = await _dio.get(
        '/contacts/',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['contacts'] != null) {
        return (response.data['contacts'] as List)
            .map((json) => AgentCRMContact.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getContacts', e);
      return [];
    }
  }

  /// Obtiene un contacto por ID
  Future<AgentCRMContact?> getContactById(String contactId) async {
    try {
      final response = await _dio.get('/contacts/$contactId');
      if (response.data != null && response.data['contact'] != null) {
        return AgentCRMContact.fromJson(response.data['contact']);
      }
      return null;
    } catch (e) {
      _handleError('getContactById', e);
      return null;
    }
  }

  /// Busca contacto por email usando múltiples estrategias
  /// GoHighLevel API v2 tiene endpoint específico para lookup por email
  Future<AgentCRMContact?> getContactByEmail(String email) async {
    final normalizedEmail = email.toLowerCase().trim();
    debugPrint('AgentCRMService.getContactByEmail: Buscando $normalizedEmail');

    // Estrategia 1: Endpoint directo de lookup por email (API v2)
    try {
      final response = await _dio.get(
        '/contacts/lookup',
        queryParameters: {
          'locationId': _locationId,
          'email': normalizedEmail,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        // Puede devolver contacto directo o lista
        if (response.data is Map<String, dynamic>) {
          if (response.data['contact'] != null) {
            debugPrint('AgentCRMService: Contacto encontrado via lookup');
            return AgentCRMContact.fromJson(response.data['contact']);
          }
          if (response.data['contacts'] != null &&
              (response.data['contacts'] as List).isNotEmpty) {
            debugPrint(
                'AgentCRMService: Contacto encontrado via lookup (lista)');
            return AgentCRMContact.fromJson(response.data['contacts'][0]);
          }
        }
      }
    } catch (e) {
      debugPrint('AgentCRMService.getContactByEmail lookup failed: $e');
    }

    // Estrategia 2: Buscar en lista de contactos con filtro por email
    try {
      final response = await _dio.get(
        '/contacts/',
        queryParameters: {
          'locationId': _locationId,
          'query': normalizedEmail,
          'limit': 20,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        List<dynamic> contacts = [];
        if (response.data is List) {
          contacts = response.data;
        } else if (response.data is Map && response.data['contacts'] != null) {
          contacts = response.data['contacts'] as List;
        }

        // Filtrar exactamente por email
        for (var c in contacts) {
          if (c is Map<String, dynamic>) {
            final contactEmail = c['email']?.toString().toLowerCase().trim();
            if (contactEmail == normalizedEmail) {
              debugPrint('AgentCRMService: Contacto encontrado en búsqueda');
              return AgentCRMContact.fromJson(c);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('AgentCRMService.getContactByEmail search failed: $e');
    }

    // Estrategia 3: Buscar todos los contactos (último recurso, caro)
    try {
      final allContacts = await getContacts(limit: 100);
      for (var contact in allContacts) {
        if (contact.email?.toLowerCase().trim() == normalizedEmail) {
          debugPrint('AgentCRMService: Contacto encontrado en lista completa');
          return contact;
        }
      }
    } catch (e) {
      debugPrint('AgentCRMService.getContactByEmail full list failed: $e');
    }

    debugPrint(
        'AgentCRMService.getContactByEmail: Contacto NO encontrado para $normalizedEmail');
    return null;
  }

  /// Obtiene o crea un contacto por email
  /// Si existe lo retorna, si no lo crea
  /// Maneja error 400 (duplicado) reintentando búsqueda con lista completa
  Future<AgentCRMContact?> getOrCreateContact({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? tags,
  }) async {
    final normalizedEmail = email.toLowerCase().trim();

    // Primero intentar encontrar el contacto existente
    var existingContact = await getContactByEmail(normalizedEmail);
    if (existingContact != null) {
      debugPrint(
          'AgentCRMService.getOrCreateContact: Contacto existente: ${existingContact.id}');
      return existingContact;
    }

    // No encontrado en búsqueda, intentar crear
    debugPrint(
        'AgentCRMService.getOrCreateContact: Intentando crear contacto...');
    try {
      final newContact = await createContact(
        email: normalizedEmail,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        tags: tags,
      );
      if (newContact != null) {
        debugPrint(
            'AgentCRMService.getOrCreateContact: Contacto creado: ${newContact.id}');
        return newContact;
      }
    } on DioException catch (e) {
      // Si es error 400 (duplicado), el contacto existe pero no lo encontramos
      if (e.response?.statusCode == 400) {
        final errorMsg = e.response?.data?.toString() ?? '';
        if (errorMsg.toLowerCase().contains('duplicate')) {
          debugPrint(
              'AgentCRMService: Error 400 duplicado - buscando en lista completa...');

          // Buscar en lista completa como último recurso
          try {
            final allContacts = await getContacts(limit: 200);
            for (var contact in allContacts) {
              if (contact.email?.toLowerCase().trim() == normalizedEmail) {
                debugPrint(
                    'AgentCRMService: ¡Contacto encontrado en lista completa!: ${contact.id}');
                return contact;
              }
            }
          } catch (_) {}

          // Si aún no lo encontramos, crear un contacto "placeholder"
          // El contacto existe en CRM pero no podemos accederlo
          debugPrint(
              'AgentCRMService: Contacto existe en CRM pero sin acceso completo');
          return AgentCRMContact(
            id: 'unknown-$normalizedEmail',
            email: normalizedEmail,
            firstName: firstName,
            lastName: lastName,
            tags: ['app-user', 'needs-sync'],
          );
        }
      }
      rethrow;
    }

    return null;
  }

  /// Crea un nuevo contacto (solo si no existe)
  /// Si falla con 400 (duplicado), significa que el contacto ya existe
  /// pero no podemos buscarlo (limitación de la API)
  Future<AgentCRMContact?> createContact({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? tags,
    Map<String, dynamic>? customFields,
  }) async {
    try {
      final body = <String, dynamic>{
        'locationId': _locationId,
        'email': email,
      };

      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (phone != null) body['phone'] = phone;
      if (tags != null) body['tags'] = tags;
      if (customFields != null) body['customFields'] = customFields;

      final response = await _dio.post('/contacts/', data: body);

      if (response.data != null && response.data['contact'] != null) {
        return AgentCRMContact.fromJson(response.data['contact']);
      }
      return null;
    } catch (e) {
      _handleError('createContact', e);
      return null;
    }
  }

  /// Actualiza un contacto existente
  Future<AgentCRMContact?> updateContact(
    String contactId, {
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    List<String>? tags,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (email != null) body['email'] = email;
      if (firstName != null) body['firstName'] = firstName;
      if (lastName != null) body['lastName'] = lastName;
      if (phone != null) body['phone'] = phone;
      if (tags != null) body['tags'] = tags;

      final response = await _dio.put('/contacts/$contactId', data: body);

      if (response.data != null && response.data['contact'] != null) {
        return AgentCRMContact.fromJson(response.data['contact']);
      }
      return null;
    } catch (e) {
      _handleError('updateContact', e);
      return null;
    }
  }

  /// Agrega tags a un contacto
  Future<bool> addTagsToContact(String contactId, List<String> tags) async {
    try {
      await _dio.post(
        '/contacts/$contactId/tags',
        data: {'tags': tags},
      );
      return true;
    } catch (e) {
      _handleError('addTagsToContact', e);
      return false;
    }
  }

  // ==================== Opportunities ====================

  /// Obtiene oportunidades
  Future<List<AgentCRMOpportunity>> getOpportunities({
    String? pipelineId,
    String? status,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'location_id': _locationId,
        'limit': limit,
      };

      if (pipelineId != null) queryParams['pipeline_id'] = pipelineId;
      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        '/opportunities/search',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['opportunities'] != null) {
        return (response.data['opportunities'] as List)
            .map((json) => AgentCRMOpportunity.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getOpportunities', e);
      return [];
    }
  }

  /// Crea una oportunidad
  Future<AgentCRMOpportunity?> createOpportunity({
    required String name,
    required String pipelineId,
    required String stageId,
    String? contactId,
    double? monetaryValue,
  }) async {
    try {
      final body = <String, dynamic>{
        'locationId': _locationId,
        'name': name,
        'pipelineId': pipelineId,
        'pipelineStageId': stageId,
        'status': 'open',
      };

      if (contactId != null) body['contactId'] = contactId;
      if (monetaryValue != null) body['monetaryValue'] = monetaryValue;

      final response = await _dio.post('/opportunities/', data: body);

      if (response.data != null) {
        return AgentCRMOpportunity.fromJson(response.data);
      }
      return null;
    } catch (e) {
      _handleError('createOpportunity', e);
      return null;
    }
  }

  // ==================== Pipelines ====================

  /// Obtiene pipelines
  Future<List<AgentCRMPipeline>> getPipelines() async {
    try {
      final response = await _dio.get(
        '/opportunities/pipelines',
        queryParameters: {'locationId': _locationId},
      );

      if (response.data != null && response.data['pipelines'] != null) {
        return (response.data['pipelines'] as List)
            .map((json) => AgentCRMPipeline.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getPipelines', e);
      return [];
    }
  }

  // ==================== Calendars/Appointments ====================

  /// Obtiene calendarios
  Future<List<Map<String, dynamic>>> getCalendars() async {
    try {
      final response = await _dio.get(
        '/calendars/',
        queryParameters: {'locationId': _locationId},
      );

      if (response.data != null && response.data['calendars'] != null) {
        return List<Map<String, dynamic>>.from(response.data['calendars']);
      }
      return [];
    } catch (e) {
      _handleError('getCalendars', e);
      return [];
    }
  }

  /// Obtiene citas de un contacto
  Future<List<AgentCRMAppointment>> getAppointments({
    String? calendarId,
    String? contactId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'locationId': _locationId,
      };

      if (calendarId != null) queryParams['calendarId'] = calendarId;
      if (contactId != null) queryParams['contactId'] = contactId;
      if (startDate != null) {
        queryParams['startTime'] = startDate.toUtc().toIso8601String();
      }
      if (endDate != null) {
        queryParams['endTime'] = endDate.toUtc().toIso8601String();
      }

      final response = await _dio.get(
        '/calendars/events',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['events'] != null) {
        return (response.data['events'] as List)
            .map((json) => AgentCRMAppointment.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getAppointments', e);
      return [];
    }
  }

  // ==================== Tags ====================

  /// Obtiene todos los tags
  Future<List<AgentCRMTag>> getTags() async {
    try {
      final response = await _dio.get(
        '/locations/$_locationId/tags',
      );

      if (response.data != null && response.data['tags'] != null) {
        return (response.data['tags'] as List)
            .map((json) => AgentCRMTag.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getTags', e);
      return [];
    }
  }

  // ==================== Users ====================

  /// Obtiene usuarios de la ubicación
  Future<List<AgentCRMUser>> getUsers() async {
    try {
      final response = await _dio.get(
        '/users/',
        queryParameters: {'locationId': _locationId},
      );

      if (response.data != null && response.data['users'] != null) {
        return (response.data['users'] as List)
            .map((json) => AgentCRMUser.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      _handleError('getUsers', e);
      return [];
    }
  }

  // ==================== Error Handling ====================

  void _handleError(String method, dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final message = error.response?.data?['message'] ?? error.message;
      debugPrint('AgentCRMService.$method error [$statusCode]: $message');
    } else {
      debugPrint('AgentCRMService.$method error: $error');
    }
  }
}

// ==================== Riverpod Providers ====================

/// Provider para el servicio de Agent CRM
final agentCRMServiceProvider = Provider<AgentCRMService>((ref) {
  return AgentCRMService.instance;
});

/// Provider para información de la ubicación
final agentCRMLocationProvider = FutureProvider<AgentCRMLocation?>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getLocation();
});

/// Provider para productos/cursos
final agentCRMProductsProvider =
    FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getProducts();
});

/// Provider para cursos específicos
final agentCRMCoursesProvider =
    FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getCourses();
});

/// Provider para membresías
final agentCRMMembershipsProvider =
    FutureProvider<List<AgentCRMProduct>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getMemberships();
});

/// Provider para contactos
final agentCRMContactsProvider =
    FutureProvider<List<AgentCRMContact>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getContacts();
});

/// Provider para buscar contacto por email
final agentCRMContactByEmailProvider =
    FutureProvider.family<AgentCRMContact?, String>((ref, email) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getContactByEmail(email);
});

/// Provider para oportunidades
final agentCRMOpportunitiesProvider =
    FutureProvider<List<AgentCRMOpportunity>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getOpportunities();
});

/// Provider para pipelines
final agentCRMPipelinesProvider =
    FutureProvider<List<AgentCRMPipeline>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getPipelines();
});

/// Provider para tags
final agentCRMTagsProvider = FutureProvider<List<AgentCRMTag>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getTags();
});

/// Provider para usuarios
final agentCRMUsersProvider = FutureProvider<List<AgentCRMUser>>((ref) async {
  final service = ref.watch(agentCRMServiceProvider);
  return service.getUsers();
});
