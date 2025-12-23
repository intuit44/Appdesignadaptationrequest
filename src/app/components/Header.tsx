import { Link } from 'react-router-dom';
import { Sparkles, ShoppingBag, BookOpen, User, LogOut } from 'lucide-react';
import { useAuthStore } from '../../store/authStore';
import { Button } from '../components/ui/button';

export default function Header() {
  const { user, signOut } = useAuthStore();

  return (
    <header className="sticky top-0 z-50 w-full border-b border-neutral-200/50 bg-white/80 backdrop-blur-xl">
      <div className="container mx-auto flex h-16 items-center justify-between px-4">
        <Link to="/" className="flex items-center gap-2">
          <div className="flex h-10 w-10 items-center justify-center rounded-xl bg-gradient-to-br from-pink-500 to-purple-600 text-white">
            <Sparkles className="h-5 w-5" />
          </div>
          <span className="bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text font-bold text-xl text-transparent">
            Fibroskin Academy
          </span>
        </Link>

        <nav className="hidden md:flex items-center gap-6">
          <Link to="/courses" className="flex items-center gap-2 text-neutral-700 hover:text-pink-600 transition-colors">
            <BookOpen className="h-4 w-4" />
            <span className="font-medium">Cursos</span>
          </Link>
          <Link to="/products" className="flex items-center gap-2 text-neutral-700 hover:text-pink-600 transition-colors">
            <ShoppingBag className="h-4 w-4" />
            <span className="font-medium">Productos</span>
          </Link>
        </nav>

        <div className="flex items-center gap-3">
          {user ? (
            <>
              <Link to="/profile">
                <Button variant="ghost" size="sm" className="gap-2">
                  <User className="h-4 w-4" />
                  <span className="hidden md:inline">Perfil</span>
                </Button>
              </Link>
              <Button 
                variant="ghost" 
                size="sm" 
                onClick={() => signOut()}
                className="gap-2"
              >
                <LogOut className="h-4 w-4" />
                <span className="hidden md:inline">Salir</span>
              </Button>
            </>
          ) : (
            <>
              <Link to="/login">
                <Button variant="ghost" size="sm">
                  Iniciar sesión
                </Button>
              </Link>
              <Link to="/register">
                <Button size="sm" className="bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700">
                  Registrarse
                </Button>
              </Link>
            </>
          )}
        </div>
      </div>
    </header>
  );
}
