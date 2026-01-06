import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';

/// Pantalla de Checkout usando WebView de WooCommerce
/// En lugar de crear la orden desde la app, agregamos productos al carrito
/// de WooCommerce y dejamos que el usuario complete el checkout en la web
class CheckoutScreen extends ConsumerStatefulWidget {
  /// Lista de items del carrito local para agregar a WooCommerce
  final List<LocalCartItem> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  String _buildCheckoutUrl() {
    final baseUrl = dotenv.env['WC_BASE_URL'] ?? 'https://fibroacademyusa.com';

    if (widget.cartItems.isEmpty) {
      return '$baseUrl/cart/';
    }

    // Construir URL para agregar todos los productos al carrito y redirigir a checkout
    // WooCommerce soporta agregar múltiples productos via query params
    // Formato: /cart/?add-to-cart=ID&quantity=QTY o usar formulario

    // Para un solo producto, usar el método directo
    if (widget.cartItems.length == 1) {
      final item = widget.cartItems.first;
      return '$baseUrl/?add-to-cart=${item.product.id}&quantity=${item.quantity}';
    }

    // Para múltiples productos, primero agregar cada uno
    // Usaremos JavaScript después de cargar para agregar los productos
    return '$baseUrl/cart/';
  }

  void _initWebView() {
    final checkoutUrl = _buildCheckoutUrl();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 Chrome/91.0.4472.120 Mobile Safari/537.36')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
            // Inyectar CSS para ocultar header/footer del sitio
            _injectStyles();
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _error = 'Error al cargar: ${error.description}';
            });
          },
          onNavigationRequest: (request) {
            final url = request.url.toLowerCase();

            // Detectar pago completado con Stripe
            if (url.contains('order-received') ||
                url.contains('thank-you') ||
                url.contains('order-completed') ||
                url.contains('payment_intent') && url.contains('succeeded')) {
              _onOrderCompleted();
              return NavigationDecision.prevent;
            }

            // Detectar cancelación
            if (url.contains('cancel') || url.contains('failed')) {
              _onPaymentFailed();
              return NavigationDecision.navigate;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(checkoutUrl));
  }

  /// Inyecta CSS para ocultar elementos innecesarios del sitio
  void _injectStyles() {
    _controller.runJavaScript('''
      (function() {
        var style = document.createElement('style');
        style.innerHTML = `
          header, .site-header, #masthead, 
          footer, .site-footer, #colophon,
          .menu-toggle, .main-navigation,
          .woocommerce-breadcrumb,
          .site-branding { display: none !important; }
          
          .site-content, .content-area, main {
            padding-top: 10px !important;
            margin-top: 0 !important;
          }
          
          body { padding-top: 0 !important; }
        `;
        document.head.appendChild(style);
      })();
    ''');
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
              _buildErrorState()
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
        icon: const Icon(Icons.close, color: Colors.white),
        onPressed: _confirmExit,
      ),
      title: Column(
        children: [
          Text(
            'Finalizar Compra',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.fSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.total > 0)
            Text(
              'Total: \$${widget.total.toStringAsFixed(2)}',
              style: TextStyle(
                color: Colors.white.withAlpha(204),
                fontSize: 12.fSize,
              ),
            ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            setState(() => _isLoading = true);
            _controller.reload();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo de la academia
            Container(
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                color: appTheme.deepOrange400.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_outline,
                size: 48.h,
                color: appTheme.deepOrange400,
              ),
            ),
            SizedBox(height: 24.h),
            CircularProgressIndicator(
              color: appTheme.deepOrange400,
              strokeWidth: 3,
            ),
            SizedBox(height: 24.h),
            Text(
              'Preparando pago seguro...',
              style: TextStyle(
                color: appTheme.blueGray80001,
                fontSize: 16.fSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Conectando con Stripe',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.fSize,
              ),
            ),
            SizedBox(height: 32.h),
            // Badges de seguridad
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSecurityBadge(Icons.verified_user, 'SSL'),
                SizedBox(width: 16.h),
                _buildSecurityBadge(Icons.credit_card, 'Stripe'),
                SizedBox(width: 16.h),
                _buildSecurityBadge(Icons.shield, 'Seguro'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityBadge(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, size: 24.h, color: Colors.green.shade600),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10.fSize,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.h,
              color: Colors.red.shade300,
            ),
            SizedBox(height: 16.h),
            Text(
              'Error al cargar el pago',
              style: TextStyle(
                fontSize: 18.fSize,
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _error ?? 'Error desconocido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.fSize,
                color: Colors.grey.shade600,
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
              ),
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Volver al carrito',
                style: TextStyle(color: appTheme.deepOrange400),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28.h),
            SizedBox(width: 8.h),
            const Text('¿Cancelar pago?'),
          ],
        ),
        content: const Text(
          'Tu orden quedará pendiente. Podrás completar el pago más tarde desde tu cuenta.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continuar pagando',
              style: TextStyle(color: appTheme.deepOrange400),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.grey.shade700,
            ),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void _onOrderCompleted() {
    // Limpiar el carrito
    ref.read(localCartProvider.notifier).clearCart();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.h),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check, color: Colors.green, size: 28.h),
            ),
            SizedBox(width: 12.h),
            const Expanded(child: Text('¡Compra Exitosa!')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total: \$${widget.total.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: appTheme.blueGray80001,
              ),
            ),
            SizedBox(height: 8.h),
            const Text(
              'Tu pago ha sido procesado exitosamente. Recibirás un email de confirmación con los detalles de tu pedido.',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: appTheme.deepOrange400,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 44.h),
            ),
            child: const Text('Ir al Inicio'),
          ),
        ],
      ),
    );
  }

  void _onPaymentFailed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text('El pago no pudo ser procesado')),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () {
            setState(() => _isLoading = true);
            _controller.reload();
          },
        ),
      ),
    );
  }
}
