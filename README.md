
## Run mysql + phpmyadmin using Docker

Guidelines from `https://medium.com/@migueldoctor/run-mysql-phpmyadmin-locally-in-3-steps-using-docker-74eb735fa1fc`:

```
docker pull mysql:8.0.1
docker pull phpmyadmin/phpmyadmin:latest

docker run --name my-own-mysql -e MYSQL_ROOT_PASSWORD=root -d -p 3306:3306 mysql:8.0.1
docker run --name my-own-phpmyadmin -d --link my-own-mysql:db -p 8081:80 phpmyadmin/phpmyadmin
```

Note: you can check your phpmyadmin we set up correctly by visiting `localhost:8081` (if password `root` does not work, waiting a few minutes might do the trick)

Create virtual environnement:
```
virtualenv -p python3 ~/bench
pip install -r requirements.txt
source ~/bench/bin/activate
```

Run application *under Google Chrome*:

```
python run.py
```
