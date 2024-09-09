FROM python:3.12-alpine
WORKDIR /app
COPY . .
RUN pip3 install --no-cache-dir flask gunicorn && apk add --no-cache curl && rm -rf /root/.cache/
ENV FLASK_APP=green.py
EXPOSE 8080
CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]