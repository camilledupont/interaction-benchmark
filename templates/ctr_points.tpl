<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>InterSeg - Annotate</title>
    <link rel="stylesheet" type="text/css" href="/style/style.css">
  </head>
  <body>
    <div id="container">
      <canvas style="border:1px solid #000000;" id="imgCanvas" width="1000" height="1000"></canvas>
      <canvas style="border:1px solid #000000;" id="drawCanvas" width="1000" height="1000"></canvas>
      <img id="img" src=""/>
      <p id="end_message">
        No more images to annotate. <a href='/'>Go back to the menu</a>
      </p>
    </div>
<script type="text/javascript" src="scripts/script.js"></script>
    <script>

      var points = [];
      var points_to_send = [];
      var image_path;

      function getFirstImage(){
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/get_first_image_ctr_points');
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.addEventListener('readystatechange', function() {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
              if(xhr.responseText=='end'){
                endMessage();
              }else{
                image_path = xhr.responseText;
                showGroundTruth();
                setTimeout(displayImage, delay);
                 window.addEventListener('click',wait_3_points);
                 window.addEventListener('mousemove', drawAxes, false);
              }
          }
        });
       xhr.send('username=' + username);

      }

     function displayPoints(){
       for (var i = 0; i < points.length; i++) {
          drawContext.beginPath();
          drawContext.arc(points[i][0], points[i][1], 8, 0, 2 * Math.PI, false);
          drawContext.fillStyle = 'DEEPPINK';
          drawContext.fill();
          drawContext.lineWidth = 5;
          drawContext.strokeStyle = '#003300';
          drawContext.stroke();
       }
     }

     function wait_3_points(e){
       var pos = getMousePos(drawCanvas, e);
       points.push([pos.x, pos.y])
       points_to_send.push([pos.x/(dpr*img_zoom), pos.y/(dpr*img_zoom)])
       if(points.length == 3){
         send_points();
       }
     }

      function drawAxes(e){
        var pos = getMousePos(drawCanvas, e);
        drawContext.clearRect(0, 0, drawCanvas.width, drawCanvas.height);
        drawContext.strokeStyle = 'pink';
        drawContext.lineWidth = 4;
        drawContext.beginPath();
        drawContext.moveTo(pos.x, 0);
        drawContext.lineTo(pos.x, drawCanvas.height);
        drawContext.stroke();
        drawContext.beginPath();
        drawContext.moveTo(0, pos.y);
        drawContext.lineTo(drawCanvas.width, pos.y);
        drawContext.stroke();
        displayPoints();
      }


      function send_points(){
        var t1 = performance.now()
        time = (t1 - t0)
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/save_ctr_points_time_to_db');
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.addEventListener('readystatechange', function() {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            if(xhr.responseText=='end'){
              endMessage();
            }else{
              image_path = xhr.responseText;
              showGroundTruth();
              setTimeout(displayImage, delay);
              points = [];
              points_to_send = [];
            }
          }
        });
        xhr.send('image_path=' + image_path +
                 '&points=' + JSON.stringify(points_to_send)+
                 '&time=' + time +
                 '&username=' + username);
      }

      getFirstImage();
    </script>
  </body>
</html>
