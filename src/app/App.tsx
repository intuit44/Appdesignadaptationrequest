import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import { Toaster } from 'sonner';
import { ModernHeader } from './components/layout/ModernHeader';
import { ModernFooter } from './components/layout/ModernFooter';
import Home from './pages/Home';
import Login from './pages/Login';
import Register from './pages/Register';
import Courses from './pages/Courses';
import Products from './pages/Products';
import Profile from './pages/Profile';

export default function App() {
  return (
    <Router>
      <div className="flex min-h-screen flex-col">
        <ModernHeader />
        <main className="flex-1">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/login" element={<Login />} />
            <Route path="/register" element={<Register />} />
            <Route path="/courses" element={<Courses />} />
            <Route path="/products" element={<Products />} />
            <Route path="/profile" element={<Profile />} />
          </Routes>
        </main>
        <ModernFooter />
        <Toaster position="top-center" richColors />
      </div>
    </Router>
  );
}