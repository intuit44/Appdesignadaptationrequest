import { Link } from 'react-router-dom';
import { Course } from '../../types';
import { Card, CardContent } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Star, Clock, Users, BookOpen } from 'lucide-react';

interface CourseCardProps {
  course: Course;
}

export default function CourseCard({ course }: CourseCardProps) {
  return (
    <Card className="group overflow-hidden border-2 border-neutral-100 transition-all hover:border-pink-200 hover:shadow-xl">
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
  );
}
