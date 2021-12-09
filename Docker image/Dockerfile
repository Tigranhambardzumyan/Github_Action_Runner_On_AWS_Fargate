FROM ubuntu:20.04

ENV RUNNER_LABELS ""
ENV AWS_REGION ""
ENV RUNNER_ALLOW_RUNASROOT=true
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    iputils-ping \
    libcurl4 \
    libicu66 \
    libunwind8 \
    netcat \
    unzip \
    jq

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        ./aws/install

COPY ./start.sh .
RUN chmod +x start.sh
RUN ls -l

CMD ["./start.sh"]
