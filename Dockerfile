FROM nginx:latest
RUN mkdir -p /usr/share/nginx/www
COPY index.html /usr/share/nginx/www
COPY /css /usr/share/nginx/www/css
COPY /images /usr/share/nginx/www/images
COPY /js /usr/share/nginx/www/js
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

# Copy the nginx configuration file. This sets up the behavior of nginx, most
# importantly, it ensure nginx listens on port 8080. Google App Engine expects
# the runtime to respond to HTTP requests at port 8080.
COPY nginx.conf /etc/nginx/nginx.conf

# create log dir configured in nginx.conf
RUN mkdir -p /var/log/app_engine

# Create a simple file to handle health checks. Health checking can be disabled
# in app.yaml, but is highly recommended. Google App Engine will send an HTTP
# request to /_ah/health and any 2xx or 404 response is considered healthy.
# Because 404 responses are considered healthy, this could actually be left
# out as nginx will return 404 if the file isn't found. However, it is better
# to be explicit.
RUN mkdir -p /usr/share/nginx/www/_ah && \
    echo "healthy" > /usr/share/nginx/www/_ah/health

# Finally, all static assets.
# ADD www/ /usr/share/nginx/www/
RUN chmod -R a+r /usr/share/nginx/www