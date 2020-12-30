from bottle import route, run, template,static_file, view, request
import numpy as np
from PIL import Image
import mysql.connector
from os import walk

dataset = 'Berkeley'
sql_port = 3306 #8889


# Getting the image names
images = []
for (dirpath, dirnames, filenames) in walk("datasets/"+dataset+"/images/"):
    images = filenames
boxes = {}
for img_name in images:
    mask = np.array(Image.open('datasets/'+dataset+'/masks/' +img_name.split('.')[0]+'.png'))
    mask = (mask > 0).astype(np.uint8)

    points =np.nonzero(mask)
    y_0 = min(points[0])
    y_1 = max(points[0])
    x_0 = min(points[1])
    x_1 = max(points[1])
    boxes[img_name] = (x_0, y_0, x_1, y_1)


@route('/')
@view('templates/index.tpl')
def index():
    context = {}
    return (context)

@route('/login')
@view('templates/login.tpl')
def login():
    context = {}
    return (context)

@route('/bounding_boxes')
@view('templates/boxes.tpl')
def play():
    context = {}
    return (context)

@route('/ctr_points')
@view('templates/ctr_points.tpl')
def play():
    context = {}
    return (context)

@route('/extreme_points')
@view('templates/extreme_points.tpl')
def extreme_points():
    context = {}
    return (context)

@route('/img/<filename>')
def server_static(filename):
    return static_file(filename, root='img/')

@route('/style/<filename>')
def server_static(filename):
    return static_file(filename, root='style/')

@route('/scripts/<filename>')
def server_static(filename):
    return static_file(filename, root='scripts/')

@route('/datasets/<filename>')
def server_static(filename):
    return static_file(filename, root='datasets/')

@route('/datasets/'+dataset+'/fusions/<filename>')
def server_static(filename):
    return static_file(filename, root='datasets/'+dataset+'/fusions/')

@route('/datasets/'+dataset+'/images/<filename>')
def server_static(filename):
    return static_file(filename, root='datasets/'+dataset+'/images/')


@route('/datasets/GrabCut/fusions/<filename>')
def server_static(filename):
    return static_file(filename, root='datasets/'+dataset+'/fusions/')

def bb_intersection_over_union(boxA, boxB):
	# determine the (x, y)-coordinates of the intersection rectangle
	xA = max(boxA[0], boxB[0])
	yA = max(boxA[1], boxB[1])
	xB = min(boxA[2], boxB[2])
	yB = min(boxA[3], boxB[3])
	# compute the area of intersection rectangle
	interArea = max(0, xB - xA + 1) * max(0, yB - yA + 1)
	# compute the area of both the prediction and ground-truth
	# rectangles
	boxAArea = (boxA[2] - boxA[0] + 1) * (boxA[3] - boxA[1] + 1)
	boxBArea = (boxB[2] - boxB[0] + 1) * (boxB[3] - boxB[1] + 1)
	# compute the intersection over union by taking the intersection
	# area and dividing it by the sum of prediction + ground-truth
	# areas - the interesection area
	iou = interArea / float(boxAArea + boxBArea - interArea)
	# return the intersection over union value
	return iou

@route('/get_first_image_points', method='POST')
def get_first_image_points():
    username = request.forms.get('username')
    new_image = get_new_image_points(username)
    if new_image is not None:
        return '/datasets/'+dataset+'/images/'+new_image
    return 'end'

@route('/get_first_image_ctr_points', method='POST')
def get_first_image_ctr_points():
    username = request.forms.get('username')
    new_image = get_new_image_ctr_points(username)
    if new_image is not None:
        return '/datasets/'+dataset+'/images/'+new_image
    return 'end'


@route('/get_first_image', method='POST')
def get_first_image():
    username = request.forms.get('username')
    new_image = get_new_image(username)
    if new_image is not None:
        return '/datasets/'+dataset+'/images/'+get_new_image(username)
    return 'end'

@route('/save_time', method='POST')
def save_time_to_db():
    image_path = request.forms.get('image_path')
    username = request.forms.get('username')
    print('username', username)
    box = eval(request.forms.get('bounding_box'))
    box_width = box[1]['x'] - box[0]['x']
    box_height = box[1]['y'] - box[0]['y']
    time = int(float(request.forms.get('time')))

    boxA = (box[0]['x'], box[0]['y'], box[1]['x'], box[1]['y'])
    iou = bb_intersection_over_union(boxA, boxes[image_path.split('/')[-1]])
    print('iou',iou)

    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )

        cursor = mydb.cursor()
        sql = ('INSERT INTO drawn_boxes(ID, username, img_path, x, y, width, height, iou, time) VALUES ')
        print(sql+str((0, username, image_path, int(box[0]['x']), int(box[0]['y']), int(box_width), int(box_height), iou, time)))
        cursor.execute(sql+str((0, username, image_path, box[0]['x'], box[0]['y'], box_width, box_height, iou, time)))
        print("affected rows = {}".format(cursor.rowcount))

        cursor.close()
        mydb.commit()
        mydb.close()
        new_image = get_new_image(username)
        print("new_image", new_image)
        if new_image is not None:
            return '/datasets/'+dataset+'/images/'+new_image
        else:
            return 'end'
    except:
        print('error')
        return None

@route('/save_ctr_points_time_to_db', method='POST')
def save_ctr_points_time_to_db():
    """Save contour points
    """
    image_path = request.forms.get('image_path')
    username = request.forms.get('username')
    print('username', username)
    points = np.array(eval(request.forms.get('points')))
    time = int(float(request.forms.get('time')))

    x_0 = min(points[:,0])
    x_1 = max(points[:,0])
    y_0 = min(points[:,1])
    y_1 = max(points[:,1])
    boxA = (x_0, y_0, x_1, y_1)
    iou = bb_intersection_over_union(boxA, boxes[image_path.split('/')[-1]])

    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )

        cursor = mydb.cursor()
        sql = ('INSERT INTO drawn_ctr_points(ID, username, img_path, point_1_x, point_2_x, point_3_x, point_1_y, point_2_y, point_3_y, iou, time) VALUES ')
        cursor.execute(sql+str((0, username, image_path, points[0][0], points[1][0], points[2][0], points[0][1], points[1][1], points[2][1] , iou, time)))
        print("affected rows = {}".format(cursor.rowcount))

        cursor.close()
        mydb.commit()
        mydb.close()
        new_image = get_new_image_ctr_points(username)
        if new_image is not None:
            return '/datasets/'+dataset+'/images/'+new_image
        else:
            return 'end'
        return get_new_image_ctr_points(username)
    except:
        print("error")
        return None

@route('/save_points', method='POST')
def save_points_time_to_db():
    """Save extreme points
    """
    image_path = request.forms.get('image_path')
    username = request.forms.get('username')
    print('username', username)
    points = np.array(eval(request.forms.get('points')))
    time = int(float(request.forms.get('time')))

    x_0 = min(points[:,0])
    x_1 = max(points[:,0])
    y_0 = min(points[:,1])
    y_1 = max(points[:,1])
    boxA = (x_0, y_0, x_1, y_1)
    iou = bb_intersection_over_union(boxA, boxes[image_path.split('/')[-1]])
    print('iou',iou)

    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )

        cursor = mydb.cursor()
        sql = ('INSERT INTO drawn_points(ID, username, img_path, point_1_x, point_2_x, point_3_x, point_4_x, point_1_y, point_2_y, point_3_y, point_4_y, iou, time) VALUES ')
        cursor.execute(sql+str((0, username, image_path, points[0][0], points[1][0], points[2][0], points[3][0], points[0][1], points[1][1], points[2][1], points[3][1] , iou, time)))
        print("affected rows = {}".format(cursor.rowcount))

        cursor.close()
        mydb.commit()
        mydb.close()
        new_image = get_new_image_points(username)
        if new_image is not None:
            return '/datasets/'+dataset+'/images/'+new_image
        else:
            return 'end'
        return get_new_image_points(username)
    except:
        print("error")
        return None


def get_new_image(username):
    print("get new image username")
    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )
        mycursor = mydb.cursor()

        mycursor.execute("SELECT img_path FROM drawn_boxes WHERE username = %s", (username,))

        list_tuples = list(mycursor)
        list_paths = [i[0] for i in list_tuples]
        mydb.close()

        for img in images:
            img_path = '/datasets/'+dataset+'/images/' + img
            if img_path not in list_paths:
                return img

    except Exception as e:
        print(e)
        return None
    return


def get_new_image_points(username):
    print("get new image")
    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )
        mycursor = mydb.cursor()

        mycursor.execute("SELECT img_path FROM drawn_points WHERE username = %s", (username,))

        list_tuples = list(mycursor)
        list_paths = [i[0] for i in list_tuples]
        mydb.close()

        for img in images:
            img_path = '/datasets/'+dataset+'/images/' + img
            if img_path not in list_paths:
                return img
        mydb.close()
    except Exception as e:
        print(e)
        return None
    return

def get_new_image_ctr_points(username):
    print("get new image")
    try:
        mydb = mysql.connector.connect(
          host="localhost",
          port=sql_port,
          user="root",
          password="root",
          database="box_time"
        )
        mycursor = mydb.cursor()

        mycursor.execute("SELECT img_path FROM drawn_ctr_points WHERE username = %s", (username,))

        list_tuples = list(mycursor)
        list_paths = [i[0] for i in list_tuples]
        mydb.close()

        for img in images:
            img_path = '/datasets/'+dataset+'/images/' + img
            if img_path not in list_paths:
                return img
        mydb.close()
    except Exception as e:
        print(e)
        return None
    return


#run(host='george.intra.cea.fr', port=8084)
run(host='george.intra.cea.fr', port=8084, debug=True, reloader=True, server='cherrypy')
