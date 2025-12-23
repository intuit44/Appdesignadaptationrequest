import { Link } from 'react-router-dom';
import { Instagram, Facebook, Youtube, Mail } from 'lucide-react';

export function ModernFooter() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-gradient-to-br from-gray-900 via-purple-900 to-pink-900 text-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          {/* Brand */}
          <div className="space-y-4">
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-white rounded-2xl flex items-center justify-center">
                <span className="gradient-text font-bold text-xl">F</span>
              </div>
              <span className="font-bold text-xl">FibroSkin Academy</span>
            </div>
            <p className="text-gray-300 text-sm">
              Tu plataforma integral de belleza profesional. Aprende, compra y conecta.
            </p>
            <div className="flex gap-3">
              <a
                href="https://instagram.com"
                target="_blank"
                rel="noopener noreferrer"
                className="p-2 bg-white/10 rounded-xl hover:bg-white/20 transition-colors"
              >
                <Instagram className="h-5 w-5" />
              </a>
              <a
                href="https://facebook.com"
                target="_blank"
                rel="noopener noreferrer"
                className="p-2 bg-white/10 rounded-xl hover:bg-white/20 transition-colors"
              >
                <Facebook className="h-5 w-5" />
              </a>
              <a
                href="https://youtube.com"
                target="_blank"
                rel="noopener noreferrer"
                className="p-2 bg-white/10 rounded-xl hover:bg-white/20 transition-colors"
              >
                <Youtube className="h-5 w-5" />
              </a>
              <a
                href="mailto:info@fibroskin.com"
                className="p-2 bg-white/10 rounded-xl hover:bg-white/20 transition-colors"
              >
                <Mail className="h-5 w-5" />
              </a>
            </div>
          </div>

          {/* Academia */}
          <div>
            <h3 className="font-semibold mb-4">Academia</h3>
            <ul className="space-y-2 text-sm text-gray-300">
              <li>
                <Link to="/courses" className="hover:text-pink-300 transition-colors">
                  Todos los Cursos
                </Link>
              </li>
              <li>
                <Link to="/courses?level=beginner" className="hover:text-pink-300 transition-colors">
                  Para Principiantes
                </Link>
              </li>
              <li>
                <Link to="/courses?category=skincare" className="hover:text-pink-300 transition-colors">
                  Cuidado de la Piel
                </Link>
              </li>
              <li>
                <Link to="/courses?category=makeup" className="hover:text-pink-300 transition-colors">
                  Maquillaje
                </Link>
              </li>
            </ul>
          </div>

          {/* Tienda */}
          <div>
            <h3 className="font-semibold mb-4">Tienda</h3>
            <ul className="space-y-2 text-sm text-gray-300">
              <li>
                <Link to="/products" className="hover:text-pink-300 transition-colors">
                  Todos los Productos
                </Link>
              </li>
              <li>
                <Link to="/products?category=skincare" className="hover:text-pink-300 transition-colors">
                  Skincare
                </Link>
              </li>
              <li>
                <Link to="/products?category=makeup" className="hover:text-pink-300 transition-colors">
                  Makeup
                </Link>
              </li>
              <li>
                <Link to="/products?deals=true" className="hover:text-pink-300 transition-colors">
                  Ofertas
                </Link>
              </li>
            </ul>
          </div>

          {/* Soporte */}
          <div>
            <h3 className="font-semibold mb-4">Soporte</h3>
            <ul className="space-y-2 text-sm text-gray-300">
              <li>
                <a href="#" className="hover:text-pink-300 transition-colors">
                  Centro de Ayuda
                </a>
              </li>
              <li>
                <a href="#" className="hover:text-pink-300 transition-colors">
                  Política de Privacidad
                </a>
              </li>
              <li>
                <a href="#" className="hover:text-pink-300 transition-colors">
                  Términos y Condiciones
                </a>
              </li>
              <li>
                <a href="#" className="hover:text-pink-300 transition-colors">
                  Contacto
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center gap-4">
          <p className="text-sm text-gray-300">
            © {currentYear} FibroSkin Beauty Academy. Todos los derechos reservados.
          </p>
          <div className="flex gap-6 text-sm text-gray-300">
            <a href="#" className="hover:text-pink-300 transition-colors">
              Política de Cookies
            </a>
            <a href="#" className="hover:text-pink-300 transition-colors">
              Accesibilidad
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
