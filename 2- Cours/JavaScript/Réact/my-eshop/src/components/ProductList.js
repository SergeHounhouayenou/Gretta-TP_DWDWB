

import React from "react";
import ProductCard from "./ProductsCard"


function ProductList({products}) //équivalent de props.products
{
    
    return (
            <div className="grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
                {
                        products.length > 0 ? (
                        products.map((product) => <ProductCard key={product.id} product = {product}/>)

                    ) : (
                        <p className="col-span-full text-center text-gray-500"> Aucun Produit trouvé </p>
                )
                }
            </div>
        );
}


export default ProductList;