import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../../store/authStore';
import { Input } from '../components/ui/input';
import { Label } from '../components/ui/label';
import { GradientButton } from '../components/base/GradientButton';
import { GradientCard } from '../components/base/GradientCard';
import { Sparkles, Mail, Lock, Apple } from 'lucide-react';
import { toast } from 'sonner';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const { signIn } = useAuthStore();
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);

    try {
      await signIn(email, password);
      toast.success('¡Bienvenido de vuelta!');
      navigate('/');
    } catch (error: any) {
      toast.error(error.message || 'Error al iniciar sesión');
    } finally {
      setLoading(false);
    }
  };

  const handleAppleSignIn = () => {
    toast.info('Sign in with Apple - Próximamente disponible');
  };

  return (
    <div className="flex min-h-[calc(100vh-4rem)] items-center justify-center p-4 relative overflow-hidden">
      {/* Gradient Background */}
      <div className="absolute inset-0 gradient-subtle opacity-60" />
      
      {/* Decorative Elements */}
      <div className="absolute top-20 right-10 w-96 h-96 bg-pink-300 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob" />
      <div className="absolute bottom-20 left-10 w-96 h-96 bg-purple-300 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000" />
      
      <div className="relative w-full max-w-md">
        <GradientCard variant="subtle" className="shadow-2xl">
          {/* Header */}
          <div className="text-center mb-8">
            <div className="mx-auto mb-4 w-16 h-16 gradient-primary rounded-3xl flex items-center justify-center shadow-glow">
              <Sparkles className="h-8 w-8 text-white" />
            </div>
            <h1 className="gradient-text mb-2">Iniciar Sesión</h1>
            <p className="text-gray-600">
              Bienvenida de vuelta a FibroSkin Academy
            </p>
          </div>

          {/* Apple Sign In Button */}
          <button
            onClick={handleAppleSignIn}
            className="w-full mb-6 px-6 py-3 bg-black text-white rounded-2xl font-semibold flex items-center justify-center gap-2 hover:bg-gray-800 transition-colors"
          >
            <Apple className="h-5 w-5" />
            Continuar con Apple
          </button>

          {/* Divider */}
          <div className="relative mb-6">
            <div className="absolute inset-0 flex items-center">
              <div className="w-full border-t border-gray-200"></div>
            </div>
            <div className="relative flex justify-center text-sm">
              <span className="px-4 bg-white text-gray-500">O continúa con email</span>
            </div>
          </div>

          {/* Login Form */}
          <form onSubmit={handleSubmit} className="space-y-5">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-gray-700">Correo Electrónico</Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
                <Input
                  id="email"
                  type="email"
                  placeholder="tu@email.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="pl-10 h-12 bg-gray-50 border-gray-200 rounded-xl focus:ring-2 focus:ring-pink-300"
                />
              </div>
            </div>

            <div className="space-y-2">
              <div className="flex items-center justify-between">
                <Label htmlFor="password" className="text-gray-700">Contraseña</Label>
                <a href="#" className="text-sm text-pink-500 hover:text-pink-600 transition-colors">
                  ¿Olvidaste tu contraseña?
                </a>
              </div>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
                <Input
                  id="password"
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="pl-10 h-12 bg-gray-50 border-gray-200 rounded-xl focus:ring-2 focus:ring-pink-300"
                />
              </div>
            </div>

            <GradientButton
              type="submit"
              variant="primary"
              size="lg"
              className="w-full"
              isLoading={loading}
            >
              {loading ? 'Iniciando sesión...' : 'Iniciar Sesión'}
            </GradientButton>
          </form>

          {/* Footer */}
          <div className="mt-8 text-center">
            <p className="text-gray-600">
              ¿No tienes cuenta?{' '}
              <Link to="/register" className="font-semibold text-pink-500 hover:text-pink-600 transition-colors">
                Regístrate gratis
              </Link>
            </p>
          </div>
        </GradientCard>

        {/* Additional Info */}
        <div className="mt-6 text-center text-sm text-gray-500">
          Al continuar, aceptas nuestros{' '}
          <a href="#" className="text-pink-500 hover:text-pink-600">Términos de Servicio</a>
          {' '}y{' '}
          <a href="#" className="text-pink-500 hover:text-pink-600">Política de Privacidad</a>
        </div>
      </div>

      {/* Custom Animation */}
      <style>{`
        @keyframes blob {
          0%, 100% { transform: translate(0, 0) scale(1); }
          33% { transform: translate(30px, -50px) scale(1.1); }
          66% { transform: translate(-20px, 20px) scale(0.9); }
        }
        .animate-blob {
          animation: blob 7s infinite;
        }
        .animation-delay-2000 {
          animation-delay: 2s;
        }
      `}</style>
    </div>
  );
}