FROM ubuntu:16.04

# copy all shell scripts and built the image
ADD . /build
RUN chmod 750 /build/system_services.sh
RUN /build/system_services.sh

# startup 
CMD ["/sbin/my_init"]
