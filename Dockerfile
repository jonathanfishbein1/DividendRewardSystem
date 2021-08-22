FROM haskell

RUN apt-get update && apt-get install -y cron

RUN touch /var/log/cron.log

COPY ./disburseTechnocracy /disburse/disburseTechnocracy

COPY ./lib /disburse/lib

RUN echo packages: /disburse/lib /disburse/disburseTechnocracy > /disburse/cabal.project

COPY ./disburseTechnocracy/disburseTechnocracy-crontab /etc/cron.d/disburseTechnocracy-crontab

RUN cabal update

WORKDIR /disburse

RUN cabal new-build lib

RUN cabal new-build disburseTechnocracy

WORKDIR /

RUN chmod +x /disburse/disburseTechnocracy/disburseTechnocracy.sh

RUN chmod 0644 /etc/cron.d/disburseTechnocracy-crontab &&\
    crontab /etc/cron.d/disburseTechnocracy-crontab

CMD [ "cron", "&&", "tail", "-f", "/var/log/cron.log" ]