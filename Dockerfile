FROM qnib/dplain-init

RUN apt-get update \
 && apt-get install -y openmpi-bin
ENV SLURM_VER=17-02-7-1 \
    MUNGE_VER=0.5.12
RUN apt-get install -y vim wget tar g++ make perl unzip build-essential libssl-dev python-dev
RUN mkdir -p /opt \
 && wget -qO- https://github.com/dun/munge/archive/munge-${MUNGE_VER}.tar.gz |tar xfz - -C /opt/ \
 && mv /opt/munge-munge-${MUNGE_VER} /opt/munge/ \
 && cd /opt/munge/ \
 && ./configure \
 && make \
 && make install
RUN wget -qO - https://github.com/SchedMD/slurm/archive/slurm-${SLURM_VER}.tar.gz |tar xfz - -C /opt/ \
 && mv /opt/slurm-slurm-${SLURM_VER} /opt/slurm
RUN cd /opt/slurm/ && \
    ./configure
RUN cd /opt/slurm/ \
 && make -j2 \
 && make install

RUN adduser --disabled-password --gecos "" slurm
VOLUME ["/var/spool/slurm/"]
COPY etc/slurm.conf /usr/local/etc/slurm.conf
