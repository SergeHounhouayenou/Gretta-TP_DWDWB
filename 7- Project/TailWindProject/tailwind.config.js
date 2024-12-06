/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ['./index.html'],
  theme: {
    extend: {
          colors:{
              primary: '#1D4ED8', //bleu principal
              secondary: "#9333EA", //Violet secondaire
              accent: "#F59E0B",
          },
          fontFamily:{
            heading: ['Poppins', 'sans-serif'],
          },
          animation:{
            fadeIn: 'fadeIn 1s ease-in-out',
          },
          keyframes:{
            fadeIn:{ 
              '0%': {opacity:0, transform:'translateY(20px)'},
            '100%': { opacity:1, transform: 'translateY(0)'},
                   },
        },
          
        
      },
  },
  plugins: [],
}

