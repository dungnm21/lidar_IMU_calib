#!/usr/bin/env bash

bag_path="/home/maudzung/work/calibration/data/li_calib_data"
#################################

# For VelodyneScan

outdoor_sync_bag_name=(
"Court-01.bag"
)
indoor_sync_bag_name=(
# "Garage-01.bag"
)

imu_topic_name=(
"/imu1/data_sync"
)

topic_lidar="/velodyne_packets"

lidar_model="VLP_16"

cov_threshold=0.0094

#################################


show_ui=true  #false
#show_ui=false

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
        echo "cov_threshold:=${cov_threshold}"
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
                          topic_lidar:="${topic_lidar}" \
                          apply_timezone_offset:="${apply_timezone_offset}" \
                          cov_threshold:="${cov_threshold}"
    done
done
