FROM python:3.9-alpine

# Install build dependencies
# RUN apk add --no-cache gcc musl-dev python3-dev

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "main.py"]