# get the python on alpine os
FROM python:3.7.4-alpine AS backend-builder

# Add scripts to the path of the running container
# we will create the script folder later
ENV PATH /scripts:$PATH

# copy the requirements from the our root to the container root
ADD ./django-polls/requirements.txt /requirements.txt

# the required Alpine packages to install uWSGI (which run our dj app in prod)
# --update: packages will be updated
# --no-cache we don't want to store anything during update
# --virtual create virtual dep to be removed later when done, this explain .tmp
RUN set -ex \
    && apk add --update --no-cache --virtual .tmp gcc musl-dev libpq linux-headers \
    && apk add postgresql-dev \
    && apk add netcat-openbsd \
    && pip install -r /requirements.txt \
    && apk del .tmp


# ADD will create app folder then
# copying our code (django app) to app folder in the container,
# then cd to /app
# copy scripts from our root to app/scripts/
ADD ./django-polls /app
WORKDIR /app
COPY ./scripts /scripts

# add executable permission
RUN chmod +x /scripts/*


# set folder for static files & media
# -p create all directories needed before /media /static
RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static

# creates new user in the image to run the app
# this user has less privilages as root, which is safer (in case of our server is compromised)
# now user have full permission of the vol folder we just created
# all other users have 755 which is only reading
RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 755 /vol/web
USER user

EXPOSE 8000
CMD ["entrypoint.sh"]
