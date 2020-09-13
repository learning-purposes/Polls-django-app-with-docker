FROM nginxinc/nginx-unprivileged:1-alpine

COPY polls.conf /etc/nginx/conf.d/polls.conf
COPY uwsgi_params /etc/nginx/uwsgi_params

USER root

RUN mkdir -p /vol/static
RUN chmod 755 /vol/static

USER nginx