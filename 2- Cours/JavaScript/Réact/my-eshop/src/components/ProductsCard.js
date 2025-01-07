import React from "react" ;
import {Link} from "react-router-dom" ;

function ProductCard({product})
    {
        return  (
                <div className="bg-white rounded-lg shadow-md p-4 flex flex-col justify-between h-full">
                        {/*Image */}
                        <div className = "flex justify-center item-center h-40">
                            <img src={ProductCard.image} alt ={ProductCard.title} 
                                className = "max-h-full object-contain"/>
                        </div>
                        {/* Informations sur le  produit */}
                    <div>
                        <h3 className = "text-lgfont-bold"> {product.title}</h3>
                        <p className = "text-gray-600 mt-2">{product.price} €</p>
                    </div>

                    {/*Bouton*/}
                        <div className = "mt-4"> 
                            <Link to={ `/product/${product.id}`} 
                                        className = "block bg-blue-400 text-white py-2 px rounded text-center hover:bg-blue-500" >
                                Voir les détails
                            </Link>
                        </div>
                </div>
                
        )
    };

    export default ProductCard