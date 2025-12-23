export interface User {
  id: string;
  email: string;
  name?: string;
  avatar?: string;
  phone?: string;
  role?: 'student' | 'instructor' | 'admin';
  enrolledCourses?: string[];
  completedCourses?: string[];
  wishlist?: string[];
  cart?: string[];
  createdAt?: Date;
  lastLogin?: Date;
}

export interface UserProfile extends User {
  bio?: string;
  location?: string;
  website?: string;
  socialLinks?: {
    instagram?: string;
    facebook?: string;
    twitter?: string;
  };
  preferences?: {
    notifications?: boolean;
    newsletter?: boolean;
    darkMode?: boolean;
  };
}

export interface UserProgress {
  courseId: string;
  progress: number;
  completedLessons: string[];
  lastAccessedLesson?: string;
  certificateUrl?: string;
  completedAt?: Date;
}
