import logo from './logo.svg';
import './App.css';
import Header from './components/Header';
import Footer from './components/Footer';
import HomePage from './pages/HomePage';
import ProductPage from './pages/ProductPage';
import { Navigate } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';

import {BrowserRouter as Router, Routes, Route} from "react-router-dom" ;
import PrivateRoute from './components/PrivateRoute';
// BrowserRouter configure le routage pour l'appli Réact
// Routes définit toutes les routes de l'application
// Route définit une route spécififique à utiliser

function App() {  {/*APP.js est le coeur de mon application*/}
  return (

      <Router>
          <div className= "flex flex-col min-h-screen">

          <Header/>  {/*Je déclare le composant 'Header' à ce point du flow*/}

          <main className="flex-grow bg-gray-100">

              <Routes>
               
                  <Route path="/" element= { <PrivateRoute> <HomePage/> </PrivateRoute>}/> 
              
                
                  {/*Les balises autofermantes peuvent être déclarées de manière classique en Réact. Il y aurait donc un slash en moins à la fin */}
                  <Route path="/product/:id" element= { <PrivateRoute> <ProductPage/> </PrivateRoute>}/> 

                  <route path="*" element={<Navigate to="/" />}/>
                  <route path="/Login" element={<LoginPage/>}/>
                  <route path="Register" element={<RegisterPage/>}/>

              </Routes>

          </main>

          <Footer/> {/*Je déclare le composant 'Foooter'à ce point du flow**/}

         
        </div>
      </Router>
  );
}

export default App;
