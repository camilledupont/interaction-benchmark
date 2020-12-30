<!DOCTYPE html>
<html lang="en" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>Chose annotation tool</title>
    <link rel="stylesheet" type="text/css" href="/style/index.css">
  </head>
  <body>
    <div class="container">
      <a id="extreme_clicks" class="mode" href="/extreme_points">
        <div class="button">
        </div>
        <p>Extreme clicking</p>
        <p class="info">Click 4 extreme points (top, right, bottom, left) in no particular order</p>
      </a>
      <a id="bounding_boxes" class="mode" href="/bounding_boxes">
        <div class="button">
        </div>
        <p>Bounding boxes</p>
        <p class="info">Click top-left and bottom-right points to draw bounding box around the object.
          Bounding box must fit perfectly to the object (not too big, not too small)</p>
      </a>
      <a id="ctr_points" class="mode" href="/ctr_points">
        <div class="button">
        </div>
        <p>3 contour points</p>
        <p class="info">Click 3 far-apart points on the object contour</p>
      </a>
    </div>
    <p class="note">Note: 10 hours for 100% accuracy or s for 85% accuracy ? choose your own pace! Refresh page (F5) to watch the ground-truth again (timer will be reset).</p>
    <script>
      if (sessionStorage.getItem('username') == null) {
        document.location.href="/login";
      }
    </script>
  </body>
</html>
