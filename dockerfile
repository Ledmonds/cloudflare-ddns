FROM alpine:latest

RUN apk --no-cache add curl && apk --no-cache add jq

COPY ./update.sh /etc/cron.d/update.sh
RUN chmod 0644 /etc/cron.d/update.sh

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
