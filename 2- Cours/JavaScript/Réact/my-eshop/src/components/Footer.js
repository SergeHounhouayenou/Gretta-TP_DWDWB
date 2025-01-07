import React from 'react' ;
import { Link} from "react-router-dom";

//composant fonctionnel
function Footer () 
    {
        return (
                <footer className="bg-gray-800 text-white p-6">
                    <div className="container mx-auto flex justify-between items-center">
                        <p className = "text-sm ">
                            &copy; 2025 Mystore
                        </p>

                    </div>
                </footer> 
            );
    }

export default Footer ;