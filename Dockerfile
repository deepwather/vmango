FROM centos:7

RUN curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo && yum install -y golang-1.12.9 libvirt-devel
RUN yum install -y make
COPY . /source
WORKDIR /source
RUN make

FROM centos:7
RUN yum install -y libvirt-libs && yum clean all
COPY --from=0 /source/bin/vmango .
COPY --from=0 /source/vmango.dist.conf vmango.conf
CMD ./vmango --config vmango.conf
