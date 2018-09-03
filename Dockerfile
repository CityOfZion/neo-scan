FROM bitwalker/alpine-elixir:1.7.3

ARG APP
ENV APP=$APP

COPY --chown=default:root ./export/$APP /opt/app

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER default

CMD ["/start.sh"]
