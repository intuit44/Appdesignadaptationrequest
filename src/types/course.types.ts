export type CourseLevel = 'Principiante' | 'Intermedio' | 'Avanzado';

export interface Course {
  id: string;
  title: string;
  description?: string;
  instructor: string;
  instructorImage?: string;
  thumbnail: string;
  duration: string;
  students: number;
  lessons: number;
  rating: number;
  reviews: number;
  price?: number;
  level: CourseLevel;
  category: string;
  tags?: string[];
  progress?: number;
  isEnrolled?: boolean;
  updatedAt?: Date;
  createdAt?: Date;
}

export interface CourseLesson {
  id: string;
  title: string;
  duration: string;
  videoUrl?: string;
  isCompleted?: boolean;
  order: number;
}

export interface CourseModule {
  id: string;
  title: string;
  description?: string;
  lessons: CourseLesson[];
  order: number;
}

export interface CourseDetails extends Course {
  modules: CourseModule[];
  requirements?: string[];
  whatYouWillLearn?: string[];
  longDescription?: string;
}
