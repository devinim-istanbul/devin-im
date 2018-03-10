FROM nginx:1.13-alpine

# Install wget and install/updates certificates
RUN apk add --no-cache --virtual .run-deps ca-certificates bash wget openssl certbot && update-ca-certificates

# Configure Nginx and apply fix for very long server names
RUN echo "daemon off;" >> /etc/nginx/nginx.conf && sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf

# Allow optional site configurations from external sources
RUN sed -i '/include \/etc\/nginx\/conf\.d\/\*\.conf;/a include /etc/nginx/sites-available/*.conf;' /etc/nginx/nginx.conf

RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled

COPY ./src /data/sites/devin.im
COPY ./build/devin.im.conf /etc/nginx/sites-available/devin.im.conf

CMD nginx
