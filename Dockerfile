from centos:centos6
MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

#add REDHAWK repo and install redhawk
COPY redhawk.repo /etc/yum.repos.d/

#add EPEL repo
RUN yum update -y && \
    yum install -y http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum install -y redhawk-devel \
                   redhawk-sdrroot-dev-mgr \
                   redhawk-sdrroot-dom-mgr \
                   redhawk-sdrroot-dom-profile \
                   bulkioInterfaces \
                   burstioInterfaces \
                   frontendInterfaces \
                   GPP \
                   GPP-profile \
                   omniORB-servers \
                   omniEvents-bootscripts \
                   sudo && yum clean all


#configure omniORB.cfg; Note: if linking another container, replace IP address
#e.g. sed -i "s/127.0.0.1/$OMNIORB_PORT_2809_TCP_ADDR/" /etc/omniORB.cfg
RUN echo "InitRef = EventService=corbaloc::127.0.0.1:11169/omniEvents" >> /etc/omniORB.cfg

#configure default user
RUN mkdir -p /home/redhawk
RUN cp /etc/skel/.bash* /home/redhawk
RUN chown -R redhawk. /home/redhawk
RUN usermod -a -G wheel --shell /bin/bash redhawk

#allow sudo access sans password
RUN echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

ENV HOME /home/redhawk
ENV OSSIEHOME /usr/local/redhawk/core
ENV SDRROOT /var/redhawk/sdr
ENV PYTHONPATH /usr/local/redhawk/core/lib64/python:/usr/local/redhawk/core/lib/python
ENV PATH /usr/local/redhawk/core/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
WORKDIR /home/redhawk
USER redhawk

ENTRYPOINT ["/usr/local/redhawk/core/bin/nodeBooter"]
CMD ["--version"]
