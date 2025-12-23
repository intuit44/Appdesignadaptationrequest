import { Product } from '../../types';
import { Card, CardContent } from './ui/card';
import { Badge } from './ui/badge';
import { Button } from './ui/button';
import { Star, ShoppingCart, Package } from 'lucide-react';
import { toast } from 'sonner';

interface ProductCardProps {
  product: Product;
}

export default function ProductCard({ product }: ProductCardProps) {
  const handleAddToCart = () => {
    toast.success(`${product.name} agregado al carrito`);
  };

  return (
    <Card className="group overflow-hidden border-2 border-neutral-100 transition-all hover:border-purple-200 hover:shadow-xl">
      <div className="relative aspect-square overflow-hidden bg-neutral-100">
        <img 
          src={product.image} 
          alt={product.name}
          className="h-full w-full object-cover transition-transform group-hover:scale-110"
        />
        {product.featured && (
          <div className="absolute left-3 top-3">
            <Badge className="bg-purple-600">
              Destacado
            </Badge>
          </div>
        )}
        {product.stock < 10 && (
          <div className="absolute right-3 top-3">
            <Badge variant="destructive">
              ¡Últimas unidades!
            </Badge>
          </div>
        )}
      </div>
      
      <CardContent className="p-5">
        <div className="mb-2">
          <Badge variant="outline" className="border-purple-200 text-purple-600">
            {product.category}
          </Badge>
        </div>

        <h3 className="mb-1 font-semibold text-neutral-900 line-clamp-1">
          {product.name}
        </h3>
        
        <p className="mb-1 text-neutral-500 text-xs">
          {product.brand}
        </p>

        <p className="mb-3 line-clamp-2 text-neutral-600 text-sm">
          {product.description}
        </p>

        <div className="mb-4 flex items-center gap-2">
          <div className="flex items-center gap-1">
            <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
            <span className="font-medium text-sm">{product.rating}</span>
          </div>
          <div className="flex items-center gap-1 text-neutral-500 text-sm">
            <Package className="h-4 w-4" />
            <span>Stock: {product.stock}</span>
          </div>
        </div>

        <div className="flex items-center justify-between gap-2">
          <div>
            <span className="font-bold text-xl text-purple-600">
              ${product.price}
            </span>
          </div>
          <Button 
            size="sm"
            onClick={handleAddToCart}
            className="bg-gradient-to-r from-purple-600 to-pink-600 hover:from-purple-700 hover:to-pink-700"
          >
            <ShoppingCart className="mr-1 h-4 w-4" />
            Agregar
          </Button>
        </div>
      </CardContent>
    </Card>
  );
}
