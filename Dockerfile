FROM julia:latest

ENV CONDA_JL_VERSION 3

RUN apt-get update \
    && apt-get install -yq --no-install-recommends \
    build-essential \
    tmux \
    unzip \
    cmake \
    && apt-get clean

RUN mkdir -p /app /sysimage
WORKDIR /app
COPY ./app/ /app
RUN julia --color=yes --depwarn=no -q -i -- deps.jl
RUN bin/compile_pkg

CMD ["/app/bin/server"]
