FROM osrf/ros:melodic-desktop-full

RUN apt-get update && apt-get install -y \
    vim python-pip python3-pip wget \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-pcl-conversions \
    ros-${ROS_DISTRO}-pcl-ros \
    ros-${ROS_DISTRO}-tf-conversions \
    && rm -rf /var/lib/apt/lists/* 
   # echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
   # echo "source /catkin_ws/devel/setup.bash" >> ~/.bashrc

RUN python3 -m pip install --upgrade pip \
    && pip3 install \
        jupyter \
        numpy \
        scipy \
        matplotlib \
        nuscenes-devkit

RUN jupyter notebook --generate-config \
    && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.password = 'sha1:b22dd1ea32ec:8d7e23c36485866b1f6d254be4eceb5fc389d0d1'" >> /root/.jupyter/jupyter_notebook_config.py \
    && echo "c.NotebookApp.open_browser = False" >> /root/.jupyter/jupyter_notebook_config.py
    

RUN python -m pip install --upgrade pip && \
    pip install \
        numpy


# when you use melodic, uncomment this to avoid confliction
RUN rm /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4hc.h && \
    ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h && \
    ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h

# ENV PCL_VERSION 1.8.0
# WORKDIR /tmp
# RUN wget https://github.com/PointCloudLibrary/pcl/archive/pcl-${PCL_VERSION}.tar.gz&& \
#     tar -zxvf pcl-${PCL_VERSION}.tar.gz && rm pcl-${PCL_VERSION}.tar.gz && \
#     mv pcl-pcl-${PCL_VERSION} pcl && \
#     mkdir -p pcl/build && cd pcl/build && \
#     cmake -DCMAKE_BUILD_TYPE=Release .. && make && \
#     make install

# RUN apt-get update && \
#     apt-get install -y \
#     libpcl-all
WORKDIR /

RUN git clone https://github.com/argoai/argoverse-api && cd argoverse-api && \
    wget https://s3.amazonaws.com/argoai-argoverse/hd_maps.tar.gz && \
    tar -zxvf hd_maps.tar.gz && \
    cd .. && pip3 install -e argoverse-api

RUN wget https://github.com/jagjeet-singh/argoverse-forecasting/raw/master/requirements.txt && \
    pip3 install -r requirements.txt

