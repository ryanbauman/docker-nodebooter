FROM centos:6
MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

#Add REDHAWK yum repo
COPY redhawk.repo /etc/yum.repos.d/

#Install REDHAWK
RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y redhawk-devel \
                   redhawk-sdrroot-dev-mgr \
                   redhawk-sdrroot-dom-mgr \
                   redhawk-sdrroot-dom-profile \
                   bulkioInterfaces \
                   burstioInterfaces \
                   frontendInterfaces \
                   GPP && \
                   yum clean all


#Configure omniORB
COPY omniORB.cfg /etc/

#Configure default user
RUN mkdir -p /home/redhawk
RUN cp /etc/skel/.bash* /home/redhawk
RUN chown -R redhawk. /home/redhawk
RUN usermod -a -G wheel --shell /bin/bash redhawk

#Define environment
ENV HOME /home/redhawk
ENV OSSIEHOME /usr/local/redhawk/core
ENV SDRROOT /var/redhawk/sdr
ENV PYTHONPATH /usr/local/redhawk/core/lib64/python:/usr/local/redhawk/core/lib/python
ENV PATH /usr/local/redhawk/core/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /home/redhawk
USER redhawk

#Run nodeconfig
RUN /var/redhawk/sdr/dev/devices/GPP/python/nodeconfig.py --silent \
    --clean \
    --gpppath=/devices/GPP \
    --disableevents \
    --domainname=REDHAWK_DEV \
    --sdrroot=/var/redhawk/sdr \
    --inplace \
    --nodename DevMgr_default

#If being used as base image; set user root and update
ONBUILD USER root
ONBUILD RUN yum update -y && yum clean all

ENTRYPOINT ["/usr/local/redhawk/core/bin/nodeBooter"]
CMD ["--version"]
