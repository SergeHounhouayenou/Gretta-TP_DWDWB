import React from "react";
import { Navigate } from "react-router-dom";

function RegisterPage()
        {
            const [email, setemail] = useState("");
            const [password, setPassword] = useState("");
            const [error, setError] = useState ("");
            const navigate = useNavigate();

            const handleRegisterPage = (e) => 
                {
                    e.preventDefault();
                    const user = JSON.parse(localStorage.getItem("users")) || [];
                        
                        if (users.find( (u) => u.email === email) )
                        {
                            setError ("Cet Email est déjà utilisé") ;
                            return ;
                        }


                    return  (
                            <div className="flex justify-center items-center h-screen">
                                <form className="bg-white p-6 rounded shadow-md w-95 space-y-4"
                                    onSubmit = {handleRegister} >
                                
                                    <h2 className="text-2xl font-bold"> Inscription</h2>
                                    {error && <p className="text-red-500"> {error} </p>}
                                    <input type= "email" placeholder ="Email" className="w-full p-2 border rounded" 
                                    value={email} onChange ={ ( e) => setEmail (e.target.value)} />

                                    <input type= "password" placeholder ="Mot de Passe" className="w-full p-2 border rounded" 
                                    value={password} onChange ={ ( e) => setPassword (e.target.value)} />   

                                    <button type="submit" className = "w-full bg-blue-500 text-white py-2 rounded hover;bg-blue-6" >
                                        S'inscrire
                                    </button>

                                    <p className = "text-sm text-center">
                                        Pasencore de compte ? 
                                        <Link className="text-blue-500" to = "/register">
                                            Se connecter
                                        </Link>    
                                    </p> 
                                </form>
                            </div>
                            )
                    }



        }


export default RegisterPage ;