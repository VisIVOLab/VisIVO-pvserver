FROM nvidia/cudagl:11.3.1-base-centos7


RUN yum -y install wget libgomp gcc-c++ zlib-devel make && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR /tmp

RUN wget --no-check-certificate "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.10&type=binary&os=Linux&downloadFile=ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64.tar.gz" && \
    mv "download.php?submit=Download&version=v5.10&type=binary&os=Linux&downloadFile=ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64.tar.gz" ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64.tar.gz && \
    tar xzf ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64.tar.gz && \
    mv ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64 /opt/ParaView-5.10.1 &&\
    rm -rf ParaView-5.10.1-egl-MPI-Linux-Python3.9-x86_64.tar.gz

RUN wget --no-check-certificate "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.1.0.tar.gz" && \
    tar xfz cfitsio-4.1.0.tar.gz && \ 
    cd cfitsio-4.1.0 && \
    ./configure --prefix=/opt/cfitsio/ --enable-reentrant && \
    make && \
    make install && \
    echo "/opt/cfitsio/lib" >> /etc/ld.so.conf.d/cfitsio.conf && \
    ldconfig

ENV LD_LIBRARY_PATH /opt/cfitsio/lib:$LD_LIBRARY_PATH

COPY Files/FitsReader.tar.gz /tmp/

RUN tar xzf FitsReader.tar.gz  && \
    cp -r FitsReader /opt/ParaView-5.10.1/lib/paraview-5.10/plugins/  && \
    sed -i '3i\\t<Plugin name=\"FitsReader\" auto_load=\"1\" \/>' /opt/ParaView-5.10.1/lib/paraview-5.10/plugins/paraview.plugins.xml  && \
    rm -rf /tmp/*

      
