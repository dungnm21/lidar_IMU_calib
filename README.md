# LI-Calib

## Overview

**LI-Calib** is a toolkit for calibrating the 6DoF rigid transformation and the time offset between a 3D LiDAR and an IMU. It's based on continuous-time batch optimization. IMU-based cost and LiDAR point-to-surfel distance are minimized jointly, which renders the calibration problem well-constrained in general scenarios. 

## **Prerequisites**

- [ROS](http://wiki.ros.org/ROS/Installation) (tested with Kinetic and Melodic)

  ```shell
  sudo apt-get install ros-melodic-pcl-ros ros-melodic-velodyne-msgs
  ```

- [Ceres](http://ceres-solver.org/installation.html) (tested with version 1.14.0)

- [Kontiki](https://github.com/APRIL-ZJU/Kontiki) (Continuous-Time Toolkit)
- Pangolin (for visualization and user interface)
- [ndt_omp](https://github.com/APRIL-ZJU/ndt_omp) 

Note that **Kontiki** and **Pangolin** are included in the *thirdparty* folder.

## Install

###  Ros melodic

```shell
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop-full
```

### Next commands

```shell
sudo apt-get install ros-melodic-pcl-ros ros-melodic-velodyne-msgs
mkdir -p ~/catkin_li_calib/src
cd ~/catkin_li_calib/src
catkin_init_workspace
git clone https://github.com/dungnm21/lidar_IMU_calib.git
cd lidar_IMU_calib/
git checkout use_ring
cd ..
wstool init
wstool merge lidar_IMU_calib/depend_pack.rosinstall
wstool update
cd lidar_IMU_calib
./build_submodules.sh
cd ../..

sudo apt-get install libgoogle-glog-dev libgflags-dev
sudo apt-get install libatlas-base-dev
sudo apt-get install libeigen3-dev
sudo apt-get install libsuitesparse-dev
git clone https://ceres-solver.googlesource.com/ceres-solver
mkdir ceres-bin
cd ceres-bin
cmake ../ceres-solver
make -j3
make test
sudo make install

sudo mv /usr/include/flann/ext/lz4.h /usr/include/flann/ext/lz4.h.bak
sudo mv /usr/include/flann/ext/lz4hc.h /usr/include/flann/ext/lz4.h.bak
sudo ln -s /usr/include/lz4.h /usr/include/flann/ext/lz4.h
sudo ln -s /usr/include/lz4hc.h /usr/include/flann/ext/lz4hc.h

catkin_make
source ./devel/setup.bash
```


## Examples

Currently the LI-Calib toolkit only support `VLP-16` but it is easy to expanded for other LiDARs. 

- Velodyne 16 channels - _VelodyneScan_:

  ```shell
  ./src/lidar_IMU_calib/calib_data_vlp16_scan.sh
  ```

- Velodyne 16 channels - _PointCloud2_:

  ```shell
  ./src/lidar_IMU_calib/calib_data_vlp16_pointcloud2.sh
  ```

- Velodyne 32 channels - _PointCloud2_:

  ```shell
  ./src/lidar_IMU_calib/calib_data_vlp32c.sh
  ```

- Pandar 64 channels - _PointCloud2_:

  ```shell
  ./src/lidar_IMU_calib/calib_data_20210412.sh
  ```

The options in `calib.sh` the have the following meaning:

- `bag_path` path to the dataset.
- `imu_topic` IMU topic.
- `bag_start` the relative start time of the rosbag [s].
- `bag_durr`  the duration for data association [s].
- `scan4map` the duration for NDT mapping [s].
- `timeOffsetPadding` maximum range in which the timeoffset may change during estimation [s].
- `ndtResolution` resolution for NDT [m].

<img src="./pic/ui.png" alt="UI" style="zoom: 50%;" />

Following the step: 

1. `Initialization`

2. `DataAssociation`

   (The users are encouraged to toggle the `show_lidar_frame` for checking the odometry result. )

3. `BatchOptimization`

4. `Refinement`

6. `Refinement`

7. ...

8. (you cloud try to optimize the time offset by choose `optimize_time_offset` then run `Refinement`)

9. `SaveMap`

All the cache results are saved in the location of the dataset.

**Note that the toolkit is implemented with only one thread, it would  response slowly while processing data. Please be patient** 

## Dataset

<img src="./pic/3imu.png" alt="3imu" style="zoom: 67%;" />

Dataset for evaluating LI_Calib are available at [here](https://drive.google.com/drive/folders/1kYLVLMlwchBsjAoNqnrwq2N2Ow5na4VD?usp=sharing). 

We utilize an MCU (stm32f1) to simulate the synchronization Pulse Per Second (PPS) signal. The LiDAR's timestamps are synchronizing to UTC, and each IMU captures the rising edge of the PPS signal and outputs the latest data with a sync signal. Considering the jitter of the internal clock of MCU, the external synchronization method has some error (within a few microseconds).

Each rosbag contains 7 topics:

```
/imu1/data          : sensor_msgs/Imu           
/imu1/data_sync     : sensor_msgs/Imu           
/imu2/data          : sensor_msgs/Imu           
/imu2/data_sync     : sensor_msgs/Imu           
/imu3/data          : sensor_msgs/Imu           
/imu3/data_sync     : sensor_msgs/Imu           
/velodyne_packets   : velodyne_msgs/VelodyneScan
```

`/imu*/data`  are raw data and the timestamps are coincide with the received time. 

`/imu*/data_sync` are the sync data, so do `/velodyne_packets` .

## Credits 

This code was developed by the  [APRIL Lab](https://github.com/APRIL-ZJU) in Zhejiang University.

For researchers that have leveraged or compared to this work, please cite the following:

Jiajun Lv, Jinhong Xu, Kewei Hu, Yong Liu, Xingxing Zuo. Targetless Calibration of LiDAR-IMU System Based on Continuous-time Batch Estimation. IROS 2020.  [[arxiv](https://arxiv.org/pdf/2007.14759.pdf)]

## License

The code is provided under the [GNU General Public License v3 (GPL-3)](https://www.gnu.org/licenses/gpl-3.0.txt).
