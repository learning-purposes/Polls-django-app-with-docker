#!/bin/sh

# exit and don't continue executing commands in case of errors
set -e

# this will collect all s files and put them in the static_root
# it's recommended to use a proxy i.e nginx to serve the static files
# this makes it easy for a proxy to serve static files from one place
python manage.py collectstatic --noinput

# command that runs our django app using uWSGI server
# serve the app on a tcp socket on port 8000
# run this as master, like in front not in the background
uwsgi --socket :8000 --master --enable-threads --module mysite.wsgi