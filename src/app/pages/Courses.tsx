import { useState } from 'react';
import { Link } from 'react-router-dom';
import { mockCourses } from '../../data/mockData';
import { Card, CardContent } from '../components/ui/card';
import { Badge } from '../components/ui/badge';
import { Button } from '../components/ui/button';
import { Star, Clock, Users, BookOpen } from 'lucide-react';

export default function Courses() {
  const [selectedLevel, setSelectedLevel] = useState<string>('Todos');
  const levels = ['Todos', 'Principiante', 'Intermedio', 'Avanzado'];

  const filteredCourses = selectedLevel === 'Todos' 
    ? mockCourses 
    : mockCourses.filter(course => course.level === selectedLevel);

  return (
    <div className="min-h-screen bg-gradient-to-b from-pink-50/50 to-white">
      <div className="container mx-auto px-4 py-12">
        {/* Header */}
        <div className="mb-12 text-center">
          <h1 className="mb-4 bg-gradient-to-r from-pink-600 to-purple-600 bg-clip-text font-bold text-4xl text-transparent md:text-5xl">
            Cursos Profesionales
          </h1>
          <p className="mx-auto max-w-2xl text-neutral-600 text-lg">
            Aprende de los expertos con nuestros cursos certificados en estética avanzada
          </p>
        </div>

        {/* Filters */}
        <div className="mb-8 flex flex-wrap items-center justify-center gap-3">
          {levels.map((level) => (
            <Button
              key={level}
              variant={selectedLevel === level ? 'default' : 'outline'}
              onClick={() => setSelectedLevel(level)}
              className={selectedLevel === level 
                ? 'bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700' 
                : 'border-2 border-pink-200 hover:bg-pink-50'
              }
            >
              {level}
            </Button>
          ))}
        </div>

        {/* Courses Grid */}
        <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
          {filteredCourses.map((course) => (
            <Card key={course.id} className="group overflow-hidden border-2 border-neutral-100 transition-all hover:border-pink-200 hover:shadow-xl">
              <div className="relative aspect-video overflow-hidden">
                <img 
                  src={course.thumbnail} 
                  alt={course.title}
                  className="h-full w-full object-cover transition-transform group-hover:scale-110"
                />
                <div className="absolute right-3 top-3">
                  <Badge className="bg-white/90 text-pink-600 backdrop-blur-sm">
                    {course.level}
                  </Badge>
                </div>
              </div>
              
              <CardContent className="p-6">
                <div className="mb-3">
                  <Badge variant="outline" className="border-pink-200 text-pink-600">
                    {course.category}
                  </Badge>
                </div>

                <h3 className="mb-2 font-semibold text-neutral-900 text-xl">
                  {course.title}
                </h3>
                
                <p className="mb-4 line-clamp-2 text-neutral-600 text-sm">
                  {course.description}
                </p>

                <div className="mb-4 flex flex-wrap items-center gap-4 text-neutral-600 text-sm">
                  <div className="flex items-center gap-1">
                    <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                    <span className="font-medium">{course.rating}</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <Users className="h-4 w-4" />
                    <span>{course.students.toLocaleString()}</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <Clock className="h-4 w-4" />
                    <span>{course.duration}</span>
                  </div>
                </div>

                <div className="flex items-center justify-between">
                  <div>
                    <span className="font-bold text-2xl text-pink-600">
                      ${course.price}
                    </span>
                  </div>
                  <Link to={`/courses/${course.id}`}>
                    <Button className="bg-gradient-to-r from-pink-600 to-purple-600 hover:from-pink-700 hover:to-purple-700">
                      Ver detalles
                      <BookOpen className="ml-2 h-4 w-4" />
                    </Button>
                  </Link>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {filteredCourses.length === 0 && (
          <div className="py-20 text-center">
            <p className="text-neutral-600 text-lg">
              No se encontraron cursos para este nivel
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
