
import React from 'react' ;
import { Link} from "react-router-dom";
import { useNavigate } from 'react-router-dom';

//composant fonctionnel
function Header () 
    {
        const navigate = useNavigate() ;
        const currentUser = JSON.parse(localStorage.getItem("currentUser")) ;
        const handleLogout = () =>
        {
            localStorage.removeItem("currentUser") ;
            navigate("/login") ;
        }
        
        return (
                <header className="bg-gradient-to-r from-blue-400 to-indigo-600 text-white shadow-lg">
                    <div className="container mx-auto flex justify-between items-center py-4 px-6">
                        <Link to = "/" className = "text-3xl font-bold">
                            MyStore
                        </Link>

                        <nav className='md:flex space-x-6'>
                            {
                                currentUser? (
                                    <div>
                                    <Link to='/' className = 'hover:text-gray-200 text-lg transition duration-200'>
                                    Accueil
                                    </Link>
                                    <Link to='/categories' className = 'hover:text-gray-200 text-lg transition duration-200'>
                                    Catégories
                                    </Link>
                                    <Link to='/cart' className = 'hover:text-gray-200 text-lg transition duration-200'>
                                    Panier
                                    </Link>        

                                        <button className = "bg-red-400 text-white px-4 py-2 rounded hover:bg-red-500" onClick= {handleLogout}>
                                            Déconnexion
                                        </button>
                                    </div>
                                ) : (
                                    <Link to="/login"
                                    className= "bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600" >
                                        Connexion
                                        </Link>

                                )
                            }
                                            
                        </nav>

                    </div>
                </header> 
            );
    }

export default Header ;