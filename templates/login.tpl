<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>InterSeg - Annotate</title>
    <link rel="stylesheet" type="text/css" href="/style/style.css">
  </head>
  <body>
    <form action="javascript:save_user()" id="username_form">
      <input type="text" name="username" placeholder="Enter a username" autofocus />
      <input type="submit" value=">"/>
    </form>

    <script>

      function save_user(){
        username = document.getElementsByName('username')[0].value;
        sessionStorage.username = username;
        document.location.href="/"; 
      }
    </script>
  </body>
</html>
