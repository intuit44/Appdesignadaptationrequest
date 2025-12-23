import { useAuthStore } from '../../store/authStore';
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import { Button } from '../components/ui/button';
import { User, Mail, BookOpen, ShoppingBag, Award } from 'lucide-react';
import { Navigate } from 'react-router-dom';

export default function Profile() {
  const { user } = useAuthStore();

  if (!user) {
    return <Navigate to="/login" replace />;
  }

  return (
    <div className="min-h-screen bg-gradient-to-b from-pink-50/30 to-white">
      <div className="container mx-auto px-4 py-12">
        <div className="mx-auto max-w-4xl">
          {/* Profile Header */}
          <Card className="mb-8 border-2 shadow-lg">
            <CardContent className="p-8">
              <div className="flex flex-col items-center gap-6 md:flex-row">
                <div className="flex h-24 w-24 items-center justify-center rounded-full bg-gradient-to-br from-pink-500 to-purple-600 text-white">
                  <User className="h-12 w-12" />
                </div>
                <div className="flex-1 text-center md:text-left">
                  <h1 className="mb-2 font-bold text-2xl text-neutral-900">
                    {user.email?.split('@')[0]}
                  </h1>
                  <div className="mb-4 flex items-center justify-center gap-2 md:justify-start">
                    <Mail className="h-4 w-4 text-neutral-500" />
                    <span className="text-neutral-600">{user.email}</span>
                  </div>
                  <Badge className="bg-gradient-to-r from-pink-600 to-purple-600">
                    Estudiante Activo
                  </Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Stats Grid */}
          <div className="mb-8 grid gap-6 md:grid-cols-3">
            <Card className="border-2 border-pink-100">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center gap-2 text-pink-600 text-lg">
                  <BookOpen className="h-5 w-5" />
                  Mis Cursos
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="font-bold text-3xl text-neutral-900">0</div>
                <p className="text-neutral-600 text-sm">Cursos inscritos</p>
              </CardContent>
            </Card>

            <Card className="border-2 border-purple-100">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center gap-2 text-purple-600 text-lg">
                  <ShoppingBag className="h-5 w-5" />
                  Compras
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="font-bold text-3xl text-neutral-900">0</div>
                <p className="text-neutral-600 text-sm">Productos adquiridos</p>
              </CardContent>
            </Card>

            <Card className="border-2 border-pink-100">
              <CardHeader className="pb-3">
                <CardTitle className="flex items-center gap-2 text-pink-600 text-lg">
                  <Award className="h-5 w-5" />
                  Certificados
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="font-bold text-3xl text-neutral-900">0</div>
                <p className="text-neutral-600 text-sm">Cursos completados</p>
              </CardContent>
            </Card>
          </div>

          {/* Empty State */}
          <Card className="border-2">
            <CardContent className="py-16 text-center">
              <div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-gradient-to-br from-pink-100 to-purple-100">
                <BookOpen className="h-8 w-8 text-pink-600" />
              </div>
              <h3 className="mb-2 font-semibold text-neutral-900 text-xl">
                Aún no tienes cursos
              </h3>
              <p className="mb-6 mx-auto max-w-md text-neutral-600">
                Comienza tu viaje de aprendizaje explorando nuestro catálogo de cursos profesionales
              </p>
              <Button className="bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700">
                Explorar cursos
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
