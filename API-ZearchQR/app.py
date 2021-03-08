from flask import Flask, jsonify, render_template, request, redirect, url_for
from flask.helpers import send_from_directory


import shutil
import os
import pyqrcode
import json

app = Flask(__name__)

database = { 
    "UsersInfo": [       
    {
        "name": "Zedd",
        "userUnique": "3A828B35-B452-47AF-9B16-4DEFFC3A1E450000",
        "loggedIn": True
    },
    {
        "name": "Micke",
        "userUnique": "3A828B35-B452-47AF-9B16-4DEFFC3A1E45123323",
        "loggedIn": True
    },
        {
        "name": "Albin",
        "userUnique": "3A828B35-B452-47AF-9B16-4DEFFC3A1E4512312321",
        "loggedIn": True
    },
        {
        "name": "Bengan",
        "userUnique": "3A828B35-B452-47AF-9B16-4DEFFC3A1E45123123",
        "loggedIn": True
    }
    ],
    "GameRoutes": [
        {
            "author" : "Zedd",
            "active" : True,
            "name": "Karlskrona - BTH",
            "image": "https://zearchqr-api.azurewebsites.net/image/Karlskrona - BTH.jpeg",
            "coordinates": {
                "startSet": True,
                "startLatitude": 56.163946,
                "startLongitude": 15.5882055,
                "goalSet": True,
                "goalLatitude": 56.182081,
                "goalLongitude": 15.5906181
            },
            "scoreboard":[
                {
                    "name": "Zedd",
                    "rank": 1,
                    "time": 10.22
                },
                {
                    "name": "Knut",
                    "rank": 2,
                    "time": 14.24
                },
                {
                    "name": "Olle",
                    "rank": 3,
                    "time": 16.22
                },
                {
                    "name": "Stina",
                    "rank": 4,
                    "time": 17.24
                },
                {
                    "name": "Bettan",
                    "rank": 5,
                    "time": 18.27
                }
            ]
        },
        {
            "author" : "Micke",
            "active" : True,
            "name": "Hemköp - Skatteverket",
            "image": "https://zearchqr-api.azurewebsites.net/image/Hemköp - Skatteverket.jpeg",
            "coordinates": {
                "startSet": True,
                "startLatitude": 56.1620742,
                "startLongitude": 15.5852899,
                "goalSet": True,
                "goalLatitude": 56.161895,
                "goalLongitude": 15.5820069
            },
            "scoreboard":[
                {
                    "name": "Zedd",
                    "rank": 1,
                    "time": 17.42
                },
                {
                    "name": "Berit",
                    "rank": 2,
                    "time": 18.76
                },
                {
                    "name": "Michael",
                    "rank": 3,
                    "time": 19.44
                },
                {
                    "name": "Gullan",
                    "rank": 4,
                    "time": 22.62
                },
                {
                    "name": "Ulla",
                    "rank": 5,
                    "time": 30.13
                }
            ]
        },
        {
            "author" : "Albin",
            "active" : True,
            "name": "Systemet - Zäta",
            "image": "https://zearchqr-api.azurewebsites.net/image/Systemet - Zäta.jpeg",
            "coordinates": {
                "startSet": True,
                "startLatitude": 56.161895,
                "startLongitude": 15.5820069,
                "goalSet": True,
                "goalLatitude": 56.1651173,
                "goalLongitude": 15.5876751
            },
            "scoreboard":[
                {
                    "name": "Zedd",
                    "rank": 1,
                    "time": 5.84
                },
                {
                    "name": "Emil",
                    "rank": 2,
                    "time": 8.96
                },
                {
                    "name": "Knut",
                    "rank": 3,
                    "time": 10.21
                },
                {
                    "name": "Gustav",
                    "rank": 4,
                    "time": 11.52
                },
                {
                    "name": "Patrik",
                    "rank": 5,
                    "time": 12.61
                }
            ]
        },
        {
            "author": "Bengan",
            "active": False,
            "name": "Trossö - Utkiken",
            "image": "https://zearchqr-api.azurewebsites.net/image/Trossö - Utkiken.jpeg",
            "coordinates": {
                "startSet": True,
                "startLatitude": 56.1611015,
                "startLongitude": 15.5773338,
                "goalSet": True,
                "goalLatitude": 56.1691909,
                "goalLongitude": 15.593952
            },
            "scoreboard":[
                {
                    "name": "Zedd",
                    "rank": 1,
                    "time": 30.82
                },
                                {
                    "name": "Ulbrit",
                    "rank": 2,
                    "time": 32.23
                },
                                {
                    "name": "Bengan",
                    "rank": 3,
                    "time": 33.55
                },
                                {
                    "name": "Gurra",
                    "rank": 4,
                    "time": 34.86
                },
                {
                    "name": "Emma",
                    "rank": 5,
                    "time": 36.94
                }
            ]
        }
    ]   
}

@app.route("/")
def root():
    data = {
        "author": "Erik Zettergren (erze19) - ZearchQR-API",
        "data": {
            "routes": {
                "/qr/"    : "The route name to show the QR for it."
            },
        },
    }
    return jsonify(data)

@app.route("/all_data")
def all_data():
    return jsonify(database)

def qr_generate(info):
    qr = pyqrcode.create(info)
    qr.svg(info + '.svg', scale=4)
    shutil.move(info + '.svg', 'static')

@app.route('/test', methods=["POST", "GET"])
def test():
    if request.method == "POST":
        qr_name = request.form["route_create"]
        return redirect(url_for("qr", name = qr_name))

    else:
        return render_template("index.html")

@app.route('/qr/<name>')
def qr(name):
    if not os.path.exists("static/" + name + ".svg"):
        qr_generate(name)
    return render_template("code.html", qr = name)


@app.route("/scoreboard")
def scoreboard():
    return jsonify(database["scoreboard"])


@app.route('/imageupload/<img_name>', methods=['GET', 'POST'])
def post_image(img_name):
    print(img_name)
    r = request.get_data()
    path = "images"
    if not os.path.exists(path):
        os.makedirs(path)

    filename = img_name
    with open(os.path.join(path, filename), 'wb') as temp_file:
        temp_file.write(r)
    

    return jsonify({"success": True})

@app.route('/image/<filename>')
def show_image(filename):
    return send_from_directory("images", filename)

@app.route('/add_route', methods=['GET', 'POST'])
def add_route():

    new_route = request.get_json()
    if(new_route["id"]):
        new_route.pop("id")

    appended_coordinates = False
    for i in database["GameRoutes"]:
        if i["name"] == new_route["name"]:
            i["active"] = new_route["active"]
            i["coordinates"] = new_route["coordinates"]
            appended_coordinates = True
            break

    if appended_coordinates == False:
        new_route["scoreboard"] = []
        print(new_route)
        database["GameRoutes"].append(new_route)

    return jsonify({"success": True})

@app.route('/add_user', methods=['GET', 'POST'])
def add_user():

    new_user = request.get_json()

    logged_in = False
    for i in database["UsersInfo"]:
        if i["name"] == new_user["name"]:
            i["loggedIn"] = new_user["loggedIn"]
            logged_in = True
            break

    if logged_in == False:
        database["UsersInfo"].append(new_user)

    return jsonify({"success": True})

@app.route('/add_score', methods=['GET', 'POST'])
def add_score():

    new_score = request.get_json()

    print(new_score)

    for i in new_score["scoreboard"]:
        try:
            if i["id"]:
                i.pop("id")
        except:
            print(i)


    for i in database["GameRoutes"]:
        if i["name"] == new_score["name"]:
            i["scoreboard"] = new_score["scoreboard"]
            break

    return jsonify({"success": True})

