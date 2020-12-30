if (sessionStorage.getItem('username') == null) {
  document.location.href="/login";
}
var username = sessionStorage.getItem('username');
var delay = 3000;

var example_img = document.getElementById('img');
var t0 = performance.now();
var anchor = {
  x: null,
  y: null
};

var dpr = 2;
var img_zoom = 1.5;
var imgCanvas = document.getElementById("imgCanvas");
var imgContext = imgCanvas.getContext("2d");
imgContext.imageSmoothingEnabled= false;
imgContext.mozImageSmoothingEnabled = false;
imgContext.scale(dpr, dpr);
imgCanvas.style.zoom = 1/dpr;


var drawCanvas = document.getElementById("drawCanvas");
var drawContext = drawCanvas.getContext("2d");
drawContext.scale(dpr, dpr);
drawCanvas.style.zoom = 1/dpr;
drawCanvas.style.cursor='crosshair';

function getMousePos(mycanvas, evt) {
  var rect = mycanvas.getBoundingClientRect();
  //console.log(evt.clientX);
  return {
    x: (evt.clientX - rect.left*1/dpr)*dpr,
    y: (evt.clientY - rect.top*1/dpr)*dpr
  };
}
function endMessage(){
  drawCanvas.style.display = "None";
  imgCanvas.style.display = "None";
  imgCanvas.style.display = "None";
  example_img.style.display = "None";
  document.getElementById('end_message').style.display = "block";
}

function showGroundTruth(){
  drawCanvas.style.display = "none";
  imgCanvas.style.display = "none";
  example_img.style.display = "inline-block";
  example_img.src = '/datasets/Berkeley/fusions/'+image_path.split('/')[image_path.split('/').length-1];
  example_img.onload = function(){
    example_img.style.marginTop = -(example_img.getBoundingClientRect().height/2)+"px";
    example_img.style.marginLeft = -(example_img.getBoundingClientRect().width/2)+"px";
  }
}

function displayImage(){
  // Draw image
  base_image = new Image();
  base_image.src = image_path;
  // example_img.src = '/datasets/Berkeley/fusions/'+image_path.split('/')[image_path.split('/').length-1];
  example_img.style.display = "None";
  var height,width;
  base_image.onload = function(){
    height = base_image.height*img_zoom;
    width = base_image.width*img_zoom;
    drawCanvas.width = width*dpr;
    drawCanvas.height = height*dpr;
    drawCanvas.style.marginLeft =  -width*dpr/2+"px";
    drawCanvas.style.marginTop = -height*dpr/2+"px";
    imgCanvas.width = width*dpr;
    imgCanvas.height = height*dpr;
    imgCanvas.style.marginLeft = -width*dpr/2+"px";
    imgCanvas.style.marginTop = -height*dpr/2+"px";
    imgContext.drawImage(base_image, 0, 0 , width*dpr, height*dpr);
      drawCanvas.style.display = "block";
      imgCanvas.style.display = "block";

    t0 = performance.now()
  }
}
