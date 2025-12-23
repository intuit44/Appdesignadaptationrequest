import { ArrowRight, Sparkles } from 'lucide-react';
import { Link } from 'react-router-dom';
import { GradientButton } from '../base/GradientButton';

export function HeroSection() {
  return (
    <section className="relative overflow-hidden py-20 lg:py-32">
      {/* Gradient Background */}
      <div className="absolute inset-0 gradient-subtle opacity-60" />
      
      {/* Decorative Elements */}
      <div className="absolute top-20 right-10 w-72 h-72 bg-pink-300 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob" />
      <div className="absolute bottom-20 left-10 w-72 h-72 bg-purple-300 rounded-full mix-blend-multiply filter blur-3xl opacity-30 animate-blob animation-delay-2000" />
      
      <div className="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          {/* Text Content */}
          <div className="space-y-8">
            <div className="inline-flex items-center gap-2 px-4 py-2 bg-white/80 backdrop-blur-sm rounded-full border border-pink-200">
              <Sparkles className="h-4 w-4 text-pink-500" />
              <span className="text-sm font-medium gradient-text">
                ¡Bienvenida a FibroSkin Academy!
              </span>
            </div>

            <h1 className="text-4xl lg:text-6xl font-bold text-gray-900 leading-tight">
              Transforma tu pasión por la{' '}
              <span className="gradient-text">belleza</span> en{' '}
              <span className="gradient-text">profesión</span>
            </h1>

            <p className="text-lg text-gray-600 leading-relaxed">
              Aprende de expertos, accede a productos profesionales y únete a una comunidad 
              de miles de profesionales de la belleza. Todo en un solo lugar.
            </p>

            <div className="flex flex-col sm:flex-row gap-4">
              <Link to="/courses">
                <GradientButton variant="primary" size="lg">
                  Explorar Cursos
                  <ArrowRight className="ml-2 h-5 w-5" />
                </GradientButton>
              </Link>
              
              <Link to="/products">
                <GradientButton variant="secondary" size="lg">
                  Ver Productos
                </GradientButton>
              </Link>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-3 gap-8 pt-8">
              <div>
                <div className="text-3xl font-bold gradient-text">50+</div>
                <div className="text-sm text-gray-600">Cursos</div>
              </div>
              <div>
                <div className="text-3xl font-bold gradient-text">10K+</div>
                <div className="text-sm text-gray-600">Estudiantes</div>
              </div>
              <div>
                <div className="text-3xl font-bold gradient-text">500+</div>
                <div className="text-sm text-gray-600">Productos</div>
              </div>
            </div>
          </div>

          {/* Image/Visual */}
          <div className="relative">
            <div className="relative aspect-square rounded-3xl overflow-hidden shadow-2xl">
              <img
                src="https://images.unsplash.com/photo-1560750588-73207b1ef5b8?w=800&h=800&fit=crop"
                alt="Beauty Professional"
                className="w-full h-full object-cover"
              />
              
              {/* Floating Cards */}
              <div className="absolute top-8 right-8 bg-white/90 backdrop-blur-sm p-4 rounded-2xl shadow-xl">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 gradient-primary rounded-xl flex items-center justify-center text-white font-bold text-xl">
                    4.9
                  </div>
                  <div>
                    <div className="font-semibold text-gray-900">Excelente</div>
                    <div className="text-sm text-gray-500">Valoración</div>
                  </div>
                </div>
              </div>

              <div className="absolute bottom-8 left-8 bg-white/90 backdrop-blur-sm p-4 rounded-2xl shadow-xl">
                <div className="flex items-center gap-3">
                  <div className="w-12 h-12 bg-green-500 rounded-xl flex items-center justify-center">
                    <Sparkles className="h-6 w-6 text-white" />
                  </div>
                  <div>
                    <div className="font-semibold text-gray-900">Certificados</div>
                    <div className="text-sm text-gray-500">Profesionales</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
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
    </section>
  );
}
