import { Sparkles } from 'lucide-react';

export default function Loading() {
  return (
    <div className="flex min-h-[400px] items-center justify-center">
      <div className="text-center">
        <div className="mx-auto mb-4 flex h-16 w-16 animate-pulse items-center justify-center rounded-full bg-gradient-to-br from-pink-500 to-purple-600">
          <Sparkles className="h-8 w-8 animate-spin text-white" />
        </div>
        <p className="text-neutral-600">Cargando...</p>
      </div>
    </div>
  );
}
