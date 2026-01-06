// Modelos para Agent CRM Pro (Go High Level)
// Contiene: Contactos, Cursos/Productos, Oportunidades, etc.

// ==================== Contact Model ====================
class AgentCRMContact {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? companyName;
  final String? address1;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? website;
  final String? timezone;
  final String? source;
  final List<String> tags;
  final Map<String, dynamic> customFields;
  final DateTime? dateAdded;
  final DateTime? dateUpdated;

  AgentCRMContact({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.companyName,
    this.address1,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.website,
    this.timezone,
    this.source,
    this.tags = const [],
    this.customFields = const {},
    this.dateAdded,
    this.dateUpdated,
  });

  String get fullName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.join(' ');
  }

  factory AgentCRMContact.fromJson(Map<String, dynamic> json) {
    return AgentCRMContact(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      email: json['email'],
      phone: json['phone'],
      companyName: json['companyName'] ?? json['company_name'],
      address1: json['address1'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      postalCode: json['postalCode'] ?? json['postal_code'],
      website: json['website'],
      timezone: json['timezone'],
      source: json['source'],
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      customFields: json['customFields'] ?? json['customField'] ?? {},
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'])
          : null,
      dateUpdated: json['dateUpdated'] != null
          ? DateTime.tryParse(json['dateUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'companyName': companyName,
      'address1': address1,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'website': website,
      'timezone': timezone,
      'source': source,
      'tags': tags,
      'customFields': customFields,
    };
  }
}

// ==================== Product/Course Model ====================
class AgentCRMProduct {
  final String id;
  final String locationId;
  final String name;
  final String productType; // SERVICE, DIGITAL, PHYSICAL
  final String? description;
  final double? price;
  final String? currency;
  final String? imageUrl;
  final List<AgentCRMProductVariant> variants;
  final bool isTaxesEnabled;
  final bool taxInclusive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgentCRMProduct({
    required this.id,
    required this.locationId,
    required this.name,
    this.productType = 'SERVICE',
    this.description,
    this.price,
    this.currency,
    this.imageUrl,
    this.variants = const [],
    this.isTaxesEnabled = false,
    this.taxInclusive = false,
    this.createdAt,
    this.updatedAt,
  });

  bool get isCourse =>
      name.toLowerCase().contains('curso') ||
      productType == 'DIGITAL' ||
      productType == 'SERVICE';

  bool get isMembership =>
      name.toLowerCase().contains('fibrolovers') ||
      name.toLowerCase().contains('membresía');

  factory AgentCRMProduct.fromJson(Map<String, dynamic> json) {
    return AgentCRMProduct(
      id: json['_id'] ?? json['id'] ?? '',
      locationId: json['locationId'] ?? '',
      name: json['name'] ?? '',
      productType: json['productType'] ?? 'SERVICE',
      description: json['description'],
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      currency: json['currency'],
      imageUrl: json['image']?['url'] ?? json['imageUrl'],
      variants: (json['variants'] as List?)
              ?.map((v) => AgentCRMProductVariant.fromJson(v))
              .toList() ??
          [],
      isTaxesEnabled: json['isTaxesEnabled'] ?? false,
      taxInclusive: json['taxInclusive'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'locationId': locationId,
      'name': name,
      'productType': productType,
      'description': description,
      'price': price,
      'currency': currency,
      'imageUrl': imageUrl,
      'isTaxesEnabled': isTaxesEnabled,
      'taxInclusive': taxInclusive,
    };
  }
}

class AgentCRMProductVariant {
  final String id;
  final String name;
  final double? price;
  final String? sku;

  AgentCRMProductVariant({
    required this.id,
    required this.name,
    this.price,
    this.sku,
  });

  factory AgentCRMProductVariant.fromJson(Map<String, dynamic> json) {
    return AgentCRMProductVariant(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] != null
          ? double.tryParse(json['price'].toString())
          : null,
      sku: json['sku'],
    );
  }
}

// ==================== Opportunity Model ====================
class AgentCRMOpportunity {
  final String id;
  final String name;
  final String? contactId;
  final String? pipelineId;
  final String? pipelineStageId;
  final String? status; // open, won, lost, abandoned
  final double? monetaryValue;
  final String? assignedTo;
  final DateTime? dateAdded;

  AgentCRMOpportunity({
    required this.id,
    required this.name,
    this.contactId,
    this.pipelineId,
    this.pipelineStageId,
    this.status,
    this.monetaryValue,
    this.assignedTo,
    this.dateAdded,
  });

  factory AgentCRMOpportunity.fromJson(Map<String, dynamic> json) {
    return AgentCRMOpportunity(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      contactId: json['contactId'] ?? json['contact_id'],
      pipelineId: json['pipelineId'] ?? json['pipeline_id'],
      pipelineStageId: json['pipelineStageId'] ?? json['pipeline_stage_id'],
      status: json['status'],
      monetaryValue: json['monetaryValue'] != null
          ? double.tryParse(json['monetaryValue'].toString())
          : null,
      assignedTo: json['assignedTo'] ?? json['assigned_to'],
      dateAdded: json['dateAdded'] != null
          ? DateTime.tryParse(json['dateAdded'])
          : null,
    );
  }
}

// ==================== Calendar/Appointment Model ====================
class AgentCRMAppointment {
  final String id;
  final String? calendarId;
  final String? contactId;
  final String title;
  final String? status; // confirmed, cancelled, showed, noshow
  final DateTime? startTime;
  final DateTime? endTime;
  final String? timezone;
  final String? notes;

  AgentCRMAppointment({
    required this.id,
    this.calendarId,
    this.contactId,
    required this.title,
    this.status,
    this.startTime,
    this.endTime,
    this.timezone,
    this.notes,
  });

  factory AgentCRMAppointment.fromJson(Map<String, dynamic> json) {
    return AgentCRMAppointment(
      id: json['id'] ?? '',
      calendarId: json['calendarId'] ?? json['calendar_id'],
      contactId: json['contactId'] ?? json['contact_id'],
      title: json['title'] ?? '',
      status: json['status'],
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'])
          : null,
      endTime:
          json['endTime'] != null ? DateTime.tryParse(json['endTime']) : null,
      timezone: json['timezone'],
      notes: json['notes'],
    );
  }
}

// ==================== Location Info Model ====================
class AgentCRMLocation {
  final String id;
  final String companyId;
  final String name;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? postalCode;
  final String? website;
  final String? email;
  final String? phone;
  final String? timezone;
  final String? logoUrl;
  final String? domain;

  AgentCRMLocation({
    required this.id,
    required this.companyId,
    required this.name,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.website,
    this.email,
    this.phone,
    this.timezone,
    this.logoUrl,
    this.domain,
  });

  factory AgentCRMLocation.fromJson(Map<String, dynamic> json) {
    final location = json['location'] ?? json;
    return AgentCRMLocation(
      id: location['id'] ?? '',
      companyId: location['companyId'] ?? '',
      name: location['name'] ?? '',
      address: location['address'],
      city: location['city'],
      state: location['state'],
      country: location['country'],
      postalCode: location['postalCode'],
      website: location['website'],
      email: location['email'],
      phone: location['phone'],
      timezone: location['timezone'],
      logoUrl: location['logoUrl'],
      domain: location['domain'],
    );
  }
}

// ==================== Pipeline Model ====================
class AgentCRMPipeline {
  final String id;
  final String name;
  final List<AgentCRMPipelineStage> stages;

  AgentCRMPipeline({
    required this.id,
    required this.name,
    this.stages = const [],
  });

  factory AgentCRMPipeline.fromJson(Map<String, dynamic> json) {
    return AgentCRMPipeline(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      stages: (json['stages'] as List?)
              ?.map((s) => AgentCRMPipelineStage.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class AgentCRMPipelineStage {
  final String id;
  final String name;
  final int position;

  AgentCRMPipelineStage({
    required this.id,
    required this.name,
    this.position = 0,
  });

  factory AgentCRMPipelineStage.fromJson(Map<String, dynamic> json) {
    return AgentCRMPipelineStage(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      position: json['position'] ?? 0,
    );
  }
}

// ==================== Tag Model ====================
class AgentCRMTag {
  final String id;
  final String name;

  AgentCRMTag({
    required this.id,
    required this.name,
  });

  factory AgentCRMTag.fromJson(Map<String, dynamic> json) {
    return AgentCRMTag(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

// ==================== User Model ====================
class AgentCRMUser {
  final String id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? role;
  final List<String> permissions;

  AgentCRMUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.role,
    this.permissions = const [],
  });

  String get fullName {
    final parts = [firstName, lastName].where((p) => p != null && p.isNotEmpty);
    return parts.join(' ');
  }

  factory AgentCRMUser.fromJson(Map<String, dynamic> json) {
    return AgentCRMUser(
      id: json['id'] ?? '',
      firstName: json['firstName'] ?? json['first_name'],
      lastName: json['lastName'] ?? json['last_name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      permissions:
          (json['permissions'] as List?)?.map((e) => e.toString()).toList() ??
              [],
    );
  }
}
