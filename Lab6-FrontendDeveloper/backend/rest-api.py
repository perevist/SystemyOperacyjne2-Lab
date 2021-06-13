import psycopg2
from flask import Flask
from flask import jsonify
from flask import request
from flask import Response
from flask_cors import CORS, cross_origin
import jsonpickle

app = Flask(__name__)
CORS(app)

class Todo:
    def __init__(self, id, content, done):
        self.id = id
        self.content = content
        self.done = done


def get_connection_to_database():
    connection = psycopg2.connect(
        user='postgres',
        password='postgres',
        host='postgres-db',
        port="5432",
        dbname='todo-app',
    )

    return connection


@app.route('/todos', methods=['GET'])
def get_todos():
    todos = []

    connection = get_connection_to_database()
    cursor = connection.cursor()
    query = 'SELECT id, content, done FROM todos'
    cursor.execute(query)
    rows = cursor.fetchall()

    for row in rows:
        todos.append(Todo(row[0], row[1], row[2]))

    connection.close()

    return Response(jsonpickle.encode(todos, unpicklable=False), mimetype='application/json')
    

@app.route('/todos', methods=['POST'])
def add_todo():
    request_data = request.get_json()

    try:
        connection = get_connection_to_database()
        cursor = connection.cursor()
        query = "INSERT INTO todos(content, done) VALUES(%(content)s, %(done)s)"
        cursor.execute(query, request_data)
        connection.commit()
    except psycopg2.Error as err:
        return jsonify(details=err.diag.message_detail), 400
    finally:
        connection.close()

    return request_data, 201


@app.route('/todos/done/<id>', methods=['PUT'])
def edit_todo(id):
    request_data = request.get_json()
    request_data['id'] = id

    try:
        connection = get_connection_to_database()
        cursor = connection.cursor()

        cursor.execute('SELECT done FROM todos WHERE id =%(id)s', request_data)
        done_from_db = cursor.fetchone()[0]
        current_state = request_data['current_state']

        # If the passed current_state is not equal to state from db - exception will be thrown 
        if (done_from_db != current_state):
            raise Exception()

        query = 'UPDATE todos SET done=%(done)s WHERE id=%(id)s'
        cursor.execute(query, request_data)
        connection.commit()
    except:
        return jsonify(details="Blad"), 400
    finally:
        connection.close()

    return jsonify(details="OK"), 200


@app.route('/todos/<id>', methods=['DELETE'])
def delete_user(id):
    request_data = {}
    request_data['id'] = id

    try:
        connection = get_connection_to_database()
        cursor = connection.cursor()

        cursor.execute('SELECT content FROM todos WHERE id =%(id)s', request_data)
        if(cursor.fetchone() == None):
            raise Exception()

        query = 'DELETE FROM todos WHERE id=%(id)s'
        cursor.execute(query, request_data)
        connection.commit()
    except:
        return jsonify(details="Blad"), 400
    finally:
        connection.close()

    return jsonify(details="OK"), 200


app.run(host="0.0.0.0")