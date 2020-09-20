lunch_others_targets=()
for device in $(curl -s https://raw.githubusercontent.com/CherishOS/android_vendor_cherish/eleven/cherish.devices)
do
    for var in user userdebug eng; do
        lunch_others_targets+=("cherish_$device-$var")
    done
done