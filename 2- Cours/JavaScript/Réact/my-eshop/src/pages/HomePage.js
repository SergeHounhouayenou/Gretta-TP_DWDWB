
import React, {useEffect, useEffects, useState} from 'react' ;
import {fetchProducts} from "../api/products";
import ProductList from '../components/ProductList';


//composant fonctionnel
function HomePage () 
    {
        //Initialisation de l'état : Crétaion du conteneur à utiliser pour les produits
        const [products, setProducts] = useState([]) ; // setProduct est une fonction associée à products dans le même conteneur (tableau vide) crée. On pourra ainsi agir dans le même contexte de ce conteneur sur.
        console.log("Initialisation : products = ", products);

        //useEffect intervient pour l'affichage dynamique dans le contenuer
        // dans cet exemple on veut une fonction asyncrone pour aller chercher les produits et ensuite les afficher dan la boîte

        useEffect(  () => 
                    {
                        console.log("useEffect est appelé ; le composant est bien monté") ;
                        

                        async function loadProducts() 
                                {
                                    const API_BASE_URL = "https://fakestoreapi.com/products";
                                    const response = await fetch(API_BASE_URL);
                                    const data = await response.json();
                                    console.log("Produits récupérés", data);
                                    setProducts(data); // mise à jour de l'état
                                    console.log("Mise à jour de l'état");
                                }
                        loadProducts() ;
                    },
                    []  // le tableau vide indique que la fonction ne va s'éxécuter qu'une seule fois.
                    );

        return (
                
                    <div className="container mx-auto p-6 ">
                        <h1 className="text-2xl font-bold mb-4">
                            Bienvenue dans notre boutique
                        </h1>
                        <ProductList products={products} />
                    </div>
               
            );
    }

export default HomePage ;