FROM python:3.9.1

RUN pip install flask && \
    pip install psycopg2 && \
    pip install jsonpickle && \
    pip install flask_cors
    
WORKDIR /app

COPY . /app

EXPOSE 5000

CMD ["python3", "rest-api.py"]