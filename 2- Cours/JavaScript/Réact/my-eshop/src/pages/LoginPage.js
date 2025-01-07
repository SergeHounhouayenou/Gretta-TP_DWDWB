import React from "react";
import { Navigate } from "react-router-dom";
import { Link } from "react-router-dom";
import { useState } from "react";
import { useNavigate } from "react-router-dom";


function LoginPage()
        {
            const [email, setEmail] = useState("");
            const [password, setPassword] = useState("");
            const [error, setError] = useState ("");
            const navigate = useNavigate();

            const handleLogin = (e) => 
                {
                    e.preventDefault();
                    //Récupérer depuis le localStorage
                    const users = JSON.parse(localStorage.getItem("users")) || [] ;
                    const user = users.find( (u) => u.email === email && u.password === password )
                    if (user) 
                    {
                        //Connexion réussie
                        localStorage.setItem("currentUser", JSON.stringify(user));
                        navigate ("/") ;
                    }
                    else
                    {
                        setError("Email ou mot de passe incorrect") ;
                    }
            }
        return  (
                    <div className="flex justify-center items-center h-screen">
                        <form className="bg-white p-6 rounded shadow-md w-95 space-y-4"
                            onSubmit = {handleLogin} >
                        
                            <h2 className="text-2xl font-bold"> Connexion</h2>
                            {error && <p className="text-red-500"> {error} </p>}
                            <input type= "email" placeholder ="Email" className="w-full p-2 border rounded" 
                            value={email} onChange ={ ( e) => setEmail (e.target.value)} />

                            <input type= "password" placeholder ="Mot de Passe" className="w-full p-2 border rounded" 
                            value={password} onChange ={ ( e) => setPassword (e.target.value)} />   

                            <button type="submit" className="w-full bg-blue-500 text-white py-2 rounded hover;bg-blue-6">
                                Se connecter
                            </button>

                            <p className = "text-sm text-center">
                                Pasencore de compte ? 
                                <Link className="text-blue-500" to = "/register">
                                    Inscrivez-vous
                                </Link>    
                            </p> 
                        </form>
                    </div>
                )
            }

export default LoginPage ;