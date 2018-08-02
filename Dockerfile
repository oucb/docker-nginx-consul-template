FROM nginx:stable
LABEL author="yeasy@github.com,oucb@outlook.com"

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install curl runit && \
    rm -rf /var/lib/apt/lists/*

ENV CT_URL https://releases.hashicorp.com/consul-template/0.19.5/consul-template_0.19.5_linux_amd64.tgz
RUN curl -L $CT_URL | tar -C /usr/local/bin -zxf -

ADD nginx.service /etc/service/nginx/run
RUN chmod a+x /etc/service/nginx/run
ADD consul-template.service /etc/service/consul-template/run
RUN chmod a+x /etc/service/consul-template/run

RUN rm -v /etc/nginx/conf.d/*
ADD nginx.conf.ctmpl /etc/consul-templates/nginx.conf.ctmpl

CMD ["/usr/bin/runsvdir", "/etc/service"]
