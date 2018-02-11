
FROM ubuntu:16.04

# Install 32bit libraries
RUN dpkg --add-architecture i386
RUN apt-get update --fix-missing
RUN apt-get install -y libc6:i386 libstdc++6:i386

RUN apt-get install -y apt-utils
RUN apt-get install -y usbutils
RUN apt-get install -y sudo

RUN apt-get install -y git && \
    apt-get install -y locales &&\
    apt-get install -y gcc-multilib &&\
# Lib dependencies for GNAT GPS
    apt-get install -y gnat-gps-common &&\
    apt-get install -y libc6 &&\
    apt-get install -y libncurses5 &&\
    apt-get install -y lib32ncurses5 &&\
    apt-get install -y libcairo2 &&\
    apt-get install -y libgdk-pixbuf2.0-0 &&\
    apt-get install -y libglib2.0-0 &&\
    apt-get install -y libgnat-4.9 &&\
    apt-get install -y libgnatcoll-gtk1.6 &&\
    apt-get install -y libgnatcoll-iconv1.6 &&\
    apt-get install -y libgnatcoll-python1.6 &&\
    apt-get install -y libgnatcoll-sqlite-bin &&\
    apt-get install -y libgnatcoll-sqlite1.6 &&\
    apt-get install -y libgnatcoll1.6 &&\
    apt-get install -y libgnatprj4.9 &&\
    apt-get install -y libgnatvsn4.9 &&\
    apt-get install -y libgtk2.0-0 &&\
    apt-get install -y libgtkada2.24.4 &&\
    apt-get install -y libpango-1.0-0 &&\
    apt-get install -y libtemplates-parser11.8.2014 &&\
    apt-get install -y libxmlada4.4.0 &&\
    apt-get install -y python-gtk2 &&\
    apt-get install -y libxinerama1:i386 &&\
    apt-get install -y libxrender1:i386 &&\
    apt-get install -y libsm6:i386 &&\
    apt-get install -y libice6:i386 &&\
    apt-get install -y libsm6 &&\
    apt-get install -y libice6 &&\
    apt-get install -y libbz2-1.0 &&\
    apt-get install -y libbz2-1.0:i386 &&\
# Libs for st-link
    apt-get install -y libusb-1.0-0 &&\
    apt-get install -y libusb-1.0-0-dev &&\
# Useful tools
    apt-get install -y vim && \
    apt-get install -y cmake && \
    apt-get install -y diffstat texinfo gawk chrpath wget cpio && \
    apt-get install -y python python-dev python-pip python-virtualenv && \
    apt-get install -y strace &&\
    apt-get install -y libgmp-dev

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -ms /bin/bash gps
RUN echo "export PATH=/usr/gnat/bin:\$PATH" >> /home/gps/.bashrc
USER gps
WORKDIR /home/gps

# INSTALLING STLINK
RUN git clone https://github.com/texane/stlink.git stlink
WORKDIR /home/gps/stlink
# We compile stlink
RUN make
# We install it system wide
WORKDIR /home/gps/stlink/build/Release
RUN mkdir ~/.stlink_install
RUN make install DESTDIR=~/.stlink_install
# End of the install

USER gps
WORKDIR /home/gps
RUN echo "export PATH=~/.stlink_install/usr/local/bin:\$PATH" >> /home/gps/.bashrc
RUN echo "export LD_LIBRARY_PATH=~/.stlink_install/usr/local/bin:\$LD_LIBRARY_PATH" >> /home/gps/.bashrc
