FROM bitwalker/alpine-elixir:1.7.0

COPY ./export/ /opt/app

COPY start.sh /start.sh
RUN chmod +x /start.sh

USER default

CMD ["/start.sh"]
