import { Link } from 'react-router-dom';
import { Sparkles, Mail, Phone, MapPin } from 'lucide-react';

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="border-t border-neutral-200 bg-neutral-50">
      <div className="container mx-auto px-4 py-12">
        <div className="grid gap-8 md:grid-cols-4">
          {/* Brand */}
          <div className="md:col-span-1">
            <Link to="/" className="mb-4 flex items-center gap-2">
              <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-pink-500 to-purple-600 text-white">
                <Sparkles className="h-5 w-5" />
              </div>
              <span className="bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text font-bold text-lg text-transparent">
                Fibroskin Academy
              </span>
            </Link>
            <p className="text-neutral-600 text-sm">
              Técnicas innovadoras de estética moderna para profesionales.
            </p>
          </div>

          {/* Enlaces */}
          <div>
            <h3 className="mb-4 font-semibold text-neutral-900">Navegación</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <Link to="/courses" className="text-neutral-600 hover:text-pink-600">
                  Cursos
                </Link>
              </li>
              <li>
                <Link to="/products" className="text-neutral-600 hover:text-pink-600">
                  Productos
                </Link>
              </li>
              <li>
                <Link to="/profile" className="text-neutral-600 hover:text-pink-600">
                  Mi Perfil
                </Link>
              </li>
            </ul>
          </div>

          {/* Categorías */}
          <div>
            <h3 className="mb-4 font-semibold text-neutral-900">Categorías</h3>
            <ul className="space-y-2 text-sm">
              <li className="text-neutral-600">Micropigmentación</li>
              <li className="text-neutral-600">Tratamientos Faciales</li>
              <li className="text-neutral-600">Fibroblast Plasma</li>
              <li className="text-neutral-600">Equipos Profesionales</li>
            </ul>
          </div>

          {/* Contacto */}
          <div>
            <h3 className="mb-4 font-semibold text-neutral-900">Contacto</h3>
            <ul className="space-y-3 text-sm">
              <li className="flex items-start gap-2">
                <Mail className="mt-0.5 h-4 w-4 text-pink-600" />
                <a href="mailto:info@fibroacademyusa.com" className="text-neutral-600 hover:text-pink-600">
                  info@fibroacademyusa.com
                </a>
              </li>
              <li className="flex items-start gap-2">
                <Phone className="mt-0.5 h-4 w-4 text-pink-600" />
                <span className="text-neutral-600">+1 (555) 123-4567</span>
              </li>
              <li className="flex items-start gap-2">
                <MapPin className="mt-0.5 h-4 w-4 text-pink-600" />
                <span className="text-neutral-600">Estados Unidos</span>
              </li>
            </ul>
          </div>
        </div>

        <div className="mt-8 border-t border-neutral-200 pt-8 text-center">
          <p className="text-neutral-600 text-sm">
            © {currentYear} Fibroskin Beauty Academy. Todos los derechos reservados.
          </p>
          <div className="mt-2">
            <a 
              href="https://fibroacademyusa.com" 
              target="_blank" 
              rel="noopener noreferrer"
              className="text-pink-600 text-sm hover:text-pink-700"
            >
              Visita nuestro sitio web oficial →
            </a>
          </div>
        </div>
      </div>
    </footer>
  );
}
