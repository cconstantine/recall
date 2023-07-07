from python:3-slim

WORKDIR /app/api-server

COPY api-server/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

WORKDIR /app


COPY . .

EXPOSE 8888/tcp
