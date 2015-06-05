# redhawk nodebooter docker image

The default entrypoint for this image runs nodeBooter and passes the "--version" option as the default command.

To run the name services, use the omniservices image:

    docker run --name omniNames --net=host --detach ryanbauman/omniservices

To run the domain manager:

	docker run --name <mydomain> --net=host --detach ryanbauman/nodebooter -D --domainname <mydomain>

This image also has a GPP Node configured (`DevMgr_cd2c5e92b2a0`). To run the device manager:

	docker run --name gpp1 --net=host --detach ryanbauman/nodebooter -d /nodes/DevMgr_cd2c5e92b2a0/DeviceManager.dcd.xml --domainname <mydomain>
