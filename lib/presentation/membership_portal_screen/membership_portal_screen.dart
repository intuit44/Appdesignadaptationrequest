import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../core/app_export.dart';

/// Pantalla que muestra el portal de membresía de Fibro Academy
/// Permite al usuario ver sus cursos en member.fibrolovers.com
class MembershipPortalScreen extends ConsumerStatefulWidget {
  /// Email del usuario para pre-llenar login (opcional)
  final String? userEmail;

  /// URL específica a abrir (opcional)
  final String? redirectUrl;

  const MembershipPortalScreen({
    super.key,
    this.userEmail,
    this.redirectUrl,
  });

  @override
  ConsumerState<MembershipPortalScreen> createState() =>
      _MembershipPortalScreenState();
}

class _MembershipPortalScreenState
    extends ConsumerState<MembershipPortalScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;
  double _loadProgress = 0;

  // URLs del portal de membresía
  static const String _baseUrl = 'https://member.fibrolovers.com';
  static const String _coursesUrl = '$_baseUrl/courses/library-v2';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  String _buildPortalUrl() {
    // Si hay URL específica, usarla
    if (widget.redirectUrl != null && widget.redirectUrl!.isNotEmpty) {
      if (widget.redirectUrl!.startsWith('http')) {
        return widget.redirectUrl!;
      }
      return '$_baseUrl${widget.redirectUrl}';
    }

    // Por defecto ir a la biblioteca de cursos
    return _coursesUrl;
  }

  void _initWebView() {
    final portalUrl = _buildPortalUrl();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
        'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36',
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          },
          onProgress: (progress) {
            setState(() {
              _loadProgress = progress / 100;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
            // Inyectar estilos para mejor experiencia mobile
            _injectStyles();
            // Pre-llenar email si está disponible y estamos en login
            if (url.contains('login') && _getUserEmail() != null) {
              _preFillEmail();
            }
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _error = 'Error al cargar: ${error.description}';
            });
          },
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();

            // Permitir navegación dentro del dominio
            if (url.contains('fibrolovers.com') ||
                url.contains('member.fibrolovers')) {
              return NavigationDecision.navigate;
            }

            // Abrir links externos en navegador externo
            if (url.startsWith('http')) {
              // Podríamos usar url_launcher aquí
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(portalUrl));
  }

  String? _getUserEmail() {
    // Primero intentar el email pasado como parámetro
    if (widget.userEmail != null && widget.userEmail!.isNotEmpty) {
      return widget.userEmail;
    }
    // Luego intentar obtener del usuario de Firebase
    final user = FirebaseAuth.instance.currentUser;
    return user?.email;
  }

  Future<void> _injectStyles() async {
    // Optimizar la visualización para mobile
    const css = '''
      (function() {
        var style = document.createElement('style');
        style.textContent = `
          /* Ocultar elementos innecesarios en app */
          .mobile-app-hide { display: none !important; }
          
          /* Mejorar espaciado para app */
          body { 
            padding-top: 0 !important;
            margin-top: 0 !important;
          }
          
          /* Asegurar que los videos sean responsivos */
          video, iframe {
            max-width: 100% !important;
            height: auto !important;
          }
        `;
        document.head.appendChild(style);
      })();
    ''';

    await _controller.runJavaScript(css);
  }

  Future<void> _preFillEmail() async {
    final email = _getUserEmail();
    if (email == null) return;

    // Intentar pre-llenar el campo de email
    final js = '''
      (function() {
        var emailInput = document.querySelector('input[type="email"]');
        if (emailInput && !emailInput.value) {
          emailInput.value = '$email';
          emailInput.dispatchEvent(new Event('input', { bubbles: true }));
        }
      })();
    ''';

    await _controller.runJavaScript(js);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.whiteA700,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            if (_error != null)
              _buildErrorWidget()
            else
              WebViewWidget(controller: _controller),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: appTheme.deepOrange400,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Mis Cursos',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() {
              _isLoading = true;
            });
            _controller.reload();
          },
        ),
        IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            _controller.loadRequest(Uri.parse(_coursesUrl));
          },
          tooltip: 'Ir a Cursos',
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo o imagen de Fibro Academy
          Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              color: appTheme.deepOrange400.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.school,
              size: 48.h,
              color: appTheme.deepOrange400,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Cargando cursos...',
            style: TextStyle(
              fontSize: 16.fSize,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: 200.h,
            child: LinearProgressIndicator(
              value: _loadProgress > 0 ? _loadProgress : null,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(appTheme.deepOrange400),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 64.h,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Error de conexión',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _error ?? 'No se pudo cargar el portal de cursos',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _error = null;
                  _isLoading = true;
                });
                _controller.reload();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: appTheme.deepOrange400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
