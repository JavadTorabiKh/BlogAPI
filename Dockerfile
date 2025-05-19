FROM python:3.9.21-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1

RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

COPY . .

RUN python manage.py migrate

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "your_project.wsgi:application"]