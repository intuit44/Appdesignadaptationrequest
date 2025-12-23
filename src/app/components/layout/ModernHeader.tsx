import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, Bell, Menu, X, User, Search } from 'lucide-react';
import { cn } from '../ui/utils';
import { useAuthStore } from '../../../store/authStore';

export function ModernHeader() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <header className="sticky top-0 z-50 bg-white/80 backdrop-blur-lg border-b border-gray-100">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2">
            <div className="w-10 h-10 gradient-primary rounded-2xl flex items-center justify-center shadow-glow">
              <span className="text-white font-bold text-xl">F</span>
            </div>
            <span className="font-bold text-xl gradient-text hidden sm:block">FibroSkin</span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center gap-8">
            <Link
              to="/"
              className="text-gray-700 hover:text-pink-500 transition-colors font-medium"
            >
              Inicio
            </Link>
            <Link
              to="/courses"
              className="text-gray-700 hover:text-pink-500 transition-colors font-medium"
            >
              Cursos
            </Link>
            <Link
              to="/products"
              className="text-gray-700 hover:text-pink-500 transition-colors font-medium"
            >
              Productos
            </Link>
          </nav>

          {/* Desktop Actions */}
          <div className="hidden md:flex items-center gap-4">
            <button className="p-2 text-gray-600 hover:text-pink-500 transition-colors relative">
              <Search className="h-5 w-5" />
            </button>
            
            <button className="p-2 text-gray-600 hover:text-pink-500 transition-colors relative">
              <ShoppingCart className="h-5 w-5" />
              <span className="absolute top-0 right-0 w-4 h-4 gradient-primary rounded-full text-white text-xs flex items-center justify-center">
                0
              </span>
            </button>

            <button className="p-2 text-gray-600 hover:text-pink-500 transition-colors relative">
              <Bell className="h-5 w-5" />
              <span className="absolute top-1 right-1 w-2 h-2 bg-pink-500 rounded-full"></span>
            </button>

            {user ? (
              <div className="flex items-center gap-3">
                <Link
                  to="/profile"
                  className="flex items-center gap-2 p-2 hover:bg-gray-100 rounded-xl transition-colors"
                >
                  <div className="w-8 h-8 gradient-primary rounded-full flex items-center justify-center text-white text-sm font-bold">
                    {user.name?.charAt(0) || 'U'}
                  </div>
                  <span className="text-sm font-medium text-gray-700">{user.name}</span>
                </Link>
                <button
                  onClick={handleLogout}
                  className="text-sm text-gray-600 hover:text-pink-500 transition-colors"
                >
                  Salir
                </button>
              </div>
            ) : (
              <div className="flex items-center gap-3">
                <Link
                  to="/login"
                  className="text-sm font-medium text-gray-700 hover:text-pink-500 transition-colors"
                >
                  Iniciar Sesión
                </Link>
                <Link
                  to="/register"
                  className="px-4 py-2 gradient-primary text-white rounded-xl hover:scale-105 transition-transform shadow-glow text-sm font-medium"
                >
                  Registrarse
                </Link>
              </div>
            )}
          </div>

          {/* Mobile Menu Button */}
          <button
            onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            className="md:hidden p-2 text-gray-600 hover:text-pink-500 transition-colors"
          >
            {mobileMenuOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
          </button>
        </div>
      </div>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="md:hidden border-t border-gray-100 bg-white">
          <div className="px-4 py-4 space-y-3">
            <Link
              to="/"
              className="block px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
              onClick={() => setMobileMenuOpen(false)}
            >
              Inicio
            </Link>
            <Link
              to="/courses"
              className="block px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
              onClick={() => setMobileMenuOpen(false)}
            >
              Cursos
            </Link>
            <Link
              to="/products"
              className="block px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
              onClick={() => setMobileMenuOpen(false)}
            >
              Productos
            </Link>
            
            {user ? (
              <>
                <Link
                  to="/profile"
                  className="block px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  Mi Perfil
                </Link>
                <button
                  onClick={() => {
                    handleLogout();
                    setMobileMenuOpen(false);
                  }}
                  className="block w-full text-left px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
                >
                  Cerrar Sesión
                </button>
              </>
            ) : (
              <>
                <Link
                  to="/login"
                  className="block px-4 py-2 text-gray-700 hover:bg-pink-50 hover:text-pink-500 rounded-xl transition-colors"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  Iniciar Sesión
                </Link>
                <Link
                  to="/register"
                  className="block px-4 py-2 gradient-primary text-white text-center rounded-xl hover:scale-105 transition-transform shadow-glow"
                  onClick={() => setMobileMenuOpen(false)}
                >
                  Registrarse
                </Link>
              </>
            )}
          </div>
        </div>
      )}
    </header>
  );
}
