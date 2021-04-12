#!/usr/bin/env bash

bag_path="/home/maudzung/work/calibration/data/li_calib_data"
# bag_path="/home/maudzung/work/calibration/data"

outdoor_sync_bag_name=(
# "Court-01.bag"
#"Court-02.bag"
#"Court-03.bag"
#"Court-04.bag"
#"Court-05.bag"
"record_court_1.bag"
)

indoor_sync_bag_name=(
# "Garage-01.bag"
#"Garage-02.bag"
#"Garage-03.bag"
#"Garage-04.bag"
#"Garage-05.bag"
)

imu_topic_name=(
"/imu1/data_sync"
# "/imu2/data_sync"
#"/imu3/data_sync"
# "/imu/data"
)

bag_start=1
bag_durr=30
scan4map=15
timeOffsetPadding=0.015
topic_lidar="/velodyne_points"

#################################

# For VelodyneScan

# outdoor_sync_bag_name=(
# "Court-01.bag"
# )

# imu_topic_name=(
# "/imu1/data_sync"
# )

# topic_lidar="/velodyne_packets"


lidar_model="VLP_16"

#################################

# For VAI Velodyne data

# bag_path="/home/maudzung/work/calibration/data/vai"
# outdoor_sync_bag_name=(
# "2021-01-12-17-47-22.bag"
# )

# imu_topic_name=(
# "/imu/data"
# )

# bag_start=1
# bag_durr=30
# scan4map=15
# timeOffsetPadding=0.015
# topic_lidar="/lidar_front/velodyne_points"
# lidar_model="VLP_32C"

#################################

#################################

# For VAI Hesai data

# bag_path="/home/maudzung/work/calibration/data/vai"
# outdoor_sync_bag_name=(
# "2021-03-24-14-16-38.bag"
# # "2021-03-24-14-19-01.bag"
# )

# imu_topic_name=(
# "/gps/imu"
# )

# bag_start=1
# bag_durr=30
# scan4map=15
# timeOffsetPadding=0.015
# topic_lidar="/hesai/pandar"
# lidar_model="PANDAR_64"

#################################

#################################

# For VAI Hesai data 2021/04/08

bag_path="/home/maudzung/work/calibration/data/data_20210408"
outdoor_sync_bag_name=(
"tien_lui_trong_ham_no_asrr.bag"
)

imu_topic_name=(
"/vehicle/imu/data_raw"
)

bag_start=1
bag_durr=30
scan4map=15
timeOffsetPadding=0.015
topic_lidar="/lidar/points_raw"
lidar_model="PANDAR_64"
apply_timezone_offset=true

#################################


show_ui=true  #false

bag_count=-1
sync_bag_name=(${outdoor_sync_bag_name[*]} ${indoor_sync_bag_name[*]})
for i in "${!sync_bag_name[@]}"; do
    let bag_count=bag_count+1

    ndtResolution=0.5	# indoor
    if [ $bag_count -lt ${#outdoor_sync_bag_name[*]} ]; then
        ndtResolution=1.0 # outdoor
    fi

    for j in "${!imu_topic_name[@]}"; do
        path_bag="$bag_path/${sync_bag_name[i]}"

        echo "topic_imu:=${imu_topic_name[j]}"
        echo "path_bag:=${path_bag}"
        echo "ndtResolution:=${ndtResolution}"
        echo "topic_lidar:=${topic_lidar}"
        echo "apply_timezone_offset:=${apply_timezone_offset}"
        echo "=============="

        roslaunch li_calib licalib_gui.launch \
                          topic_imu:="${imu_topic_name[j]}" \
                          path_bag:="${path_bag}" \
                          bag_start:="${bag_start}" \
                          bag_durr:="${bag_durr}" \
                          scan4map:="${scan4map}" \
                          lidar_model:=${lidar_model} \
                          time_offset_padding:="${timeOffsetPadding}"\
                          ndtResolution:="${ndtResolution}" \
                          show_ui:="${show_ui}" \
                          topic_lidar:="${topic_lidar}"
                          apply_timezone_offset:="${apply_timezone_offset}"
    done
done
