FROM alpine:3.6

ENV SERVER_ADDR     0.0.0.0
ENV SERVER_PORT     61080
ENV PASSWORD        pwd
ENV METHOD          none
ENV PROTOCOL        auth_chain_b
ENV PROTOCOLPARAM   1
ENV OBFS            tls1.2_ticket_auth
ENV TIMEOUT         300
# ENV DNS_ADDR        8.8.8.8
# ENV DNS_ADDR_2      8.8.4.4
# ENV TRANSFER        50
ENV speed_limit_per_con 300
# ENV speed_limit_per_user    1000

ENV OPTIONS         -v

ARG BRANCH=manyuser
ARG WORK=~


RUN apk --no-cache add python \
    libsodium \
    wget


RUN mkdir -p $WORK && \
    wget -qO- --no-check-certificate https://github.com/shadowsocksr-backup/shadowsocksr/archive/$BRANCH.tar.gz | tar -xzf - -C $WORK


WORKDIR $WORK/shadowsocksr-$BRANCH/shadowsocks

RUN ln -s server.py httpd-server.py

EXPOSE $SERVER_PORT

CMD python httpd-server.py -p $SERVER_PORT -k $PASSWORD -m $METHOD -O $PROTOCOL -o $OBFS -G $(($PROTOCOLPARAM+1)) -t $TIMEOUT -s $speed_limit_per_con  --fast-open $OPTIONS

