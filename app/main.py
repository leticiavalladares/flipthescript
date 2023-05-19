from flask import Flask, render_template, send_from_directory, request
from flask_mysqldb import MySQL
import json

app = Flask("flipthescript")

@app.route("/")
def homepage():
    return render_template('index.html')

if __name__ == "__main__":
    app.run(host="127.0.0.1")