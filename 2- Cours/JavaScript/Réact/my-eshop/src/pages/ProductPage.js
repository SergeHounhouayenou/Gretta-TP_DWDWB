import React from "react" ;
import { useParams } from "react-router-dom";
import {useNavigate} from "react-router-dom";

function productPage()
    {
        const [product, setProduct]=useState(null);
        const {id} = useParams(); // récupère id du product
        const [error, setError] = useState (null);
        const navigate = useNavigate() ;
        useEffect( () => 
            {
                async function loadProduct( )
                    {
                        try {
                                setError(null);
                                const data = await fetchProductById(id);
                                if (!data) {
                                                throw new Error();
                                            }
                                setProduct(data);
                            }
                            
                        catch (err)
                            {
                                setError(err);
                                navigate("/")
                            }
                    }
                                console.log(product);
                            
            
                    loadProduct() ;
            }, [id]);

            // Si les produits ne se téléchargent pas
            if (!product)
            {
                return  (
                            <div className  = "flex justify-center itemscenter items-center">
                                <p> Chargement du produit </p>
                            </div>
                        ) ; // Sans cette gestion des erreur de téléchargement le code 
                            // peut planter souvvent voir critiquement car les problèmes de latences sont récurrents. 
            }
        
        return(
            <div className="container mx-auto p-6">
                <div className="bg-white rounded-lg shadow-md p-6 grid grid-cols-1 lg:grid-cols-2 gap-6">
                    {/*Colonne de l'image*/}
                    <div className="flex justify-center items-center">
                        <img src={product.image} alt={product.title}
                            className ="max-w-full max-h-95 object-contain rounded"/>
                    </div>
                    {/* Colonne des détails */ }
                    <div className="flex flex-col">

                            <div>
                                    <h1 className = "text-3xl font-bold mb-4">{product.title}</h1>
                                        <p className="text-sm text-gray-500 mb2">
                                            categorie : {product.category}
                                        </p>

                                        <div className= "flex items-center mb-4">
                                            <p className="text-yellows-500 mr-2"> {/* // On veut former un tableau de valeurs*/ }
                                                {Array.from(  
                                                    {
                                                        lenght : Math.round(product.retting?.rate || 0)
                                                    }, 
                                                    (_,i) => "⭐" ) }    {/* Construir un tableau à remplir aves les étoies 
                                                    // underscore sert de place holder pour que la fonctionne 
                                                    marche m^me si on se fout de cette valeur */ }
                                            </p> 
                                              <span className="text-sm text-gray-500"> ( {product.rating?.count || 0} avis)</span>
                                        </div>
                                </div>
                                <p className = "text-gray-700 text-lg mb-6">
                                    {product.description}
                                </p>
                                <div> 
                                    <p className = "text-2xl font-bold mb-4"> {product.price} euros 
                                    </p>
                                        <button className = "w-full bg-blue-400 text-white py-2 px-4 rounded hover:bg-blue-600 transition">
                                            Ajouter au panier
                                        </button>
                                </div>
                            </div>
                    </div>
               
            </div>
        );
    }


    export default productPage