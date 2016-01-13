FROM docker-redhawk
MAINTAINER Ryan Bauman <ryanbauman@gmail.com>

# Run nodeconfig as RHUSER
USER ${RHUSER}
WORKDIR ${SDRROOT}
RUN dev/devices/GPP/python/nodeconfig.py --silent \
    --clean \
    --gpppath=/devices/GPP \
    --disableevents \
    --domainname=REDHAWK_DEV \
    --sdrroot=${SDRROOT} \
    --inplace \
    --nodename DevMgr_default

# Set user back to root.
ONBUILD USER root

# Re-forward environment variables downstream from upstream
ONBUILD ENV RHUSER ${RHUSER}
ONBUILD ENV HOME ${HOME}
ONBUILD ENV OSSIEHOME ${OSSIEHOME}
ONBUILD ENV SDRROOT ${SDRROOT}
ONBUILD ENV PYTHONPATH ${PYTHONPATH}
ONBUILD ENV PATH ${PATH}

ENTRYPOINT ${OSSIEHOME}/bin/nodeBooter
CMD ["--version"]
