from flask import Flask, render_template, send_from_directory, request
from flask_mysqldb import MySQL
import json
#from secrets import get_secret


app = Flask("flipthescript")

#------- AWS RDS -------
#db_config = get_secret('flipthescript', region_name='eu-central-1')

#app.config["MYSQL_PASSWORD"]  = db_config["MYSQL_PASSWORD"]
#app.config["MYSQL_HOST"]      = db_config["MYSQL_HOST"]
#app.config["MYSQL_USER"]      = db_config['MYSQL_USER']
#app.config["MYSQL_DB"]        = db_config['MYSQL_DB']
#---------------------------------------------------------

#------- Local ----------
app.config["MYSQL_PASSWORD"]  = ''
app.config["MYSQL_HOST"]      = '127.0.0.1'
app.config["MYSQL_USER"]      = ''
app.config["MYSQL_DB"]        = 'flipthescript'
#---------------------------------------------------------

mysql = MySQL(app)

@app.route("/")
def homepage():
    cursor = mysql.connection.cursor()
    query_string = "SELECT title, date, topic, author_name, id FROM article, author WHERE article.author_id = author.author_id ORDER BY id LIMIT 10;"
    cursor.execute(query_string)  
    data = cursor.fetchall()
    cursor.close()
    return render_template("hello.html", article_data=data)

@app.route("/static/<path>")
def static_style(path):
   return send_from_directory('static', path)


@app.route("/article/<int:article_id>")
def article_details(article_id):
    cursor = mysql.connection.cursor()
    query_string = "SELECT * FROM article, author, analysis WHERE article.id = {0} AND author.author_id = {0} AND analysis.analysis_id = {0}".format(article_id)
    cursor.execute(query_string)  
    data = cursor.fetchall()
    cursor.close()
    return render_template("article.html", article_data=data)

if __name__ == "__main__":
    app.run(host="0.0.0.0")