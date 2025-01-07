

const API_BASE_URL = "https://fakestoreapi.com/products";


export async function fetchProducts() 
{
    const response = await fetch(API_BASE_URL);
    return response.json();
}

export async function fetchProductById(id) 
    {
        const response = await fetch(`${API_BASE_URL} /${id}`);
        return response.json();
}
 
    