FROM elixir:1.6.5 as release

COPY . /code

ENV MIX_ENV=prod

RUN cd /code && mix local.hex --force
RUN cd /code && mix local.rebar --force
RUN cd /code && rm -Rf _build && mix deps.get
RUN cd /code && mix compile
RUN cd /code && mix phx.digest
RUN cd /code && mix release --env=prod
RUN mkdir /export
RUN RELEASE_DIR=`ls -d /code/_build/prod/rel/neoscan/releases/*/` && tar -xf "$RELEASE_DIR/neoscan.tar.gz" -C /export

FROM elixir:1.6.5

COPY --from=release /export/ /opt/app
#RUN chown -R default /opt/app/

COPY start.sh /start.sh
RUN chmod +x /start.sh

#USER default

CMD ["/start.sh"]
