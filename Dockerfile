FROM python:3.9-slim

# تنظیم محیط
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# نصب وابستگی‌ها
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# کپی کردن فایل requirements
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# کپی کردن کد بلاگ
COPY . .

# اجرای migrations و جمع‌آوری استاتیک (اگه لازم باشه)
RUN python manage.py migrate
RUN python manage.py collectstatic --noinput

# اجرای سرور جنگو
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "blog.wsgi:application"]