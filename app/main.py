from flask import Flask, render_template, send_from_directory, request
from flask_mysqldb import MySQL
import json
import boto3
from botocore.exceptions import ClientError

app = Flask("flipthescript")

def get_secret():
    secret_name_pwd  = "movie-db-password"
    secret_name_host = "db-endpoint"
    region_name      = "eu-central-1"

    session = boto3.session.Session()
    client = session.client(
        service_name='secretsmanager',
        region_name=region_name
    )

    try:
        get_secret_value_response_pwd = client.get_secret_value(
            SecretId=secret_name_pwd
        )
        get_secret_value_response_host = client.get_secret_value(
            SecretId=secret_name_host
        )
    except ClientError as e:
        raise e

    app.config["MYSQL_PASSWORD"]  = get_secret_value_response_pwd['SecretString']
    app.config["MYSQL_HOST"]      = get_secret_value_response_host['SecretString']


app.config["MYSQL_USER"] = "root"
app.config["MYSQL_DB"]   = "flipthescript"

mysql = MySQL(app)

@app.route("/")
def homepage():
    return render_template('index.html')

@app.route("/static/<path>")
def static_style(path):
   return send_from_directory('static', path)


@app.route("/article-table/")
def list_movie_table():
    cursor = mysql.connection.cursor()
    query_string = "SELECT * FROM article;"
    cursor.execute(query_string)  
    data = cursor.fetchall()
    cursor.close()
    return render_template("article.html", article_data=data)

if __name__ == "__main__":
    app.run(host="127.0.0.1")