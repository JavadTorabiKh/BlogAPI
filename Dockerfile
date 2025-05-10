FROM python:3.8-slim

# set .env
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# install dependency
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# copy requirements
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# migrations
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput

# run server
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "blog.wsgi:application"]