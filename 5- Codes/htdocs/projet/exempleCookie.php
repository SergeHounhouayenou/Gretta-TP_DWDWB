<?php

setcookie 
(
    string $name
    [,
        string $path = "" 
        [,
            string $domain = ""
            [,
                bool $secure = FALSE 
                [,
                    bool $httponly = FALSE
                ]
            ]
        ]
    ]
)

// setcookie('login', 'Ryan', time() + 365*24*60*60);
// echo "Le login de l'utilisateur est : ".$_COOKIE  ... etc.





?>