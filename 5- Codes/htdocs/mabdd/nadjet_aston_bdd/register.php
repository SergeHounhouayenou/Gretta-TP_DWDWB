<!DOCTYPE html>
<html lang="fr">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="css/main.css">
</head>

<body class="my-4container">
    <br>
    <br>
    <h1>Formulaire d'inscription</h1>
    <!-- Modèles de patterns : http://html5pattern.com/ -->
    <form action="register_action.php" method="post">
    <div class="modal-body">
        <div class="form-group">
            <label for="name">Prénom :</label>
            <input type="text" id="name" name="name" class="form-control" maxlength="30" pattern="[A-Za-zàâäéèëêîïôöùûü\-]{2,30}" required>
        </div>
        <div class="form-group">
            <label for="mail">Courriel :</label>
            <input type="email" name="mail" id="mail" class="form-control" required>
        </div>
        <div class="form-group">
            <label for="dob">Date de naissance :</label>
            <input type="date" name="dob" id="dob" pattern="[0-9]{4}-(0[1-9]|1[012])-(0[1-9]|1[0-9]|2[0-9]|3[01])" class="form-control">
        </div>
        <div class="form-group">
            <label for="gender">Genre :</label>
            <select name="gender" id="gender" class="form-control">
                <option value="">--- Faites votre choix ---</option>
                <option value="F">Féminin</option>
                <option value="M">Masculin</option>
                <option value="N">Neutre</option>
            </select>
        </div>
        <div class="form-check">
            <input type="radio" name="news" id="news_y" value="1" checked>
            <label for="news_y">Je veux recevoir la newsletter</label>
        </div>
        <div class="form-check">
            <input type="radio" name="news" id="news_n" value="0">
            <label for="news_n">Ca ne m'intéresse pas</label>
        </div>
        <input type="submit" value="S'inscrire" class="btn btn-info">
    </form>
</body>

</html>