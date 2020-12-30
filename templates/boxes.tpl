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
      var bounding_box;
      function startDrawingBox(e){
        var pos = getMousePos(drawCanvas, e);
        anchor = pos
        console.log("startDrawingBox");
        window.addEventListener('mousemove', followMouse, false);
      }

      function followMouse(e) {
        var pos = getMousePos(drawCanvas, e);
        posx = pos.x;
        posy = pos.y;
        //drawContext.clearRect(0, 0, drawCanvas.width, drawCanvas.height);
        drawAxes(e);
        drawContext.strokeStyle = 'pink';
        drawContext.lineWidth = 4;
        drawContext.beginPath();
        drawContext.rect(anchor.x, anchor.y, posx - anchor.x, posy - anchor.y);
        drawContext.stroke();
        window.removeEventListener('click', startDrawingBox);
        window.removeEventListener('mousemove', drawAxes);
        window.addEventListener('click', validateBox, false);
      }

      function drawAxes(e){
        var pos = getMousePos(drawCanvas, e);
        pos.x = pos.x;
        pos.y = pos.y;
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
      }

      function validateBox(e){
        var pos = getMousePos(imgCanvas, e);
        console.log("POS");
        console.log(pos);
        console.log("Anchor");
        console.log(anchor);
        var top_left_corner = {x: Math.min(anchor.x, pos.x)/(dpr*img_zoom), y: Math.min(anchor.y, pos.y)/(dpr*img_zoom)};
        var bottom_right_corner = {x: Math.max(anchor.x, pos.x)/(dpr*img_zoom), y: Math.max(anchor.y, pos.y)/(dpr*img_zoom)};
        bounding_box = [top_left_corner, bottom_right_corner];
        // bounding_box_field.value = JSON.stringify(bounding_box)
        // sendbox_form.submit();
        window.removeEventListener('click', validateBox);
        window.removeEventListener('mousemove', followMouse);
        //getMask();
        var t1 = performance.now()
        console.log("Drawing a box took " + (t1 - t0) + " milliseconds.")
        sendTimeAndBox((t1 - t0))
      }

      function sendTimeAndBox(time){
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/save_time');
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.addEventListener('readystatechange', function() {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
              if(xhr.responseText=='end'){
                endMessage();
              }else{
                image_path = xhr.responseText;
                showGroundTruth();
                setTimeout(displayImage, delay);
                window.addEventListener('click',startDrawingBox);
                window.addEventListener('mousemove', drawAxes);
              }
          }
        });
        xhr.send('image_path=' + image_path +
                 '&bounding_box=' + JSON.stringify(bounding_box)+
                 '&time=' + time +
                 '&username=' + username);
      }
      var image_path;
      function getFirstImage(){
        var xhr = new XMLHttpRequest();
        xhr.open('POST', '/get_first_image');
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.addEventListener('readystatechange', function() {
          if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
              if(xhr.responseText=='end'){
                endMessage();
              }else{
                image_path = xhr.responseText;
                showGroundTruth();
                setTimeout(displayImage, delay);
                 window.addEventListener('click',startDrawingBox);
                 window.addEventListener('mousemove', drawAxes, false);
              }
          }
        });
       xhr.send('username=' + username);

      }
      getFirstImage();
    </script>
  </body>
</html>
