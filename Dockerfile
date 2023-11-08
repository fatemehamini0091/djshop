FROM python:3.11.6-alpine3.18


ENV PYTHONUNBUFFERED 1
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1


RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip
RUN apk add --update --no-cache postgresql-client
RUN apk add --update  postgresql-client build-base postgresql-dev musl-dev linux-headers libffi-dev libxslt-dev libxml2-dev
RUN    apk add --update --no-cache --virtual .tmp-deps \
        build-base postgresql-dev musl-dev linux-headers libffi-dev libjpeg zlib-dev jpeg-dev gcc musl-dev libxslt libxml2


WORKDIR src

COPY ./requirements /requirements
COPY ./scripts /scripts
COPY ./src /src

EXPOSE 8000

RUN /py/bin/pip install -r /requiremets/development.txt

RUN chmod -R +x /scripts && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    adduser --disabled-password --no-createhome djshop && \
    chown -R djshop:djshop /vol && \
    chmod -R 755 /vol


ENV PATH="/scripts:/py/bin:$Path"

USER djshop

CMD ["run.sh"]