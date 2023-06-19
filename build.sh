#!/usr/bin/env bash

cat << 'EOF' > /etc/apk/repositories
http://dl-cdn.alpinelinux.org/alpine/v3.17/main
http://dl-cdn.alpinelinux.org/alpine/v3.17/community
EOF

export ROOTFS=/rootfs
mkdir -p $ROOTFS

for i in "$@"
do
case $i in
    -p=*|--packages=*)
    PACKAGES="${i#*=}"
    shift
    ;;
    -d=*|--dev-packages=*)
    DEV_PACKAGES="${i#*=}"
    shift
    ;;
    *)
        echo "Unknow argument"
    ;;
esac
done

declare -A urls=(
    [testing]=edge/testing
    [main]=edge/main
    [community]=edge/community
    [edge-testing]=edge/testing
    [edge-main]=edge/main
    [edge-community]=edge/community
    [stable-main]=latest-stable/main
    [stable-community]=latest-stable/community
    [v30]=v3.0/main
    [v30testing]=v3.0/testing
    [v31]=v3.1/main
    [v32]=v3.2/main
    [v33]=v3.3/main
    [v33community]=v3.3/community
    [v34]=v3.4/main
    [v34community]=v3.4/community
    [v35]=v3.5/main
    [v35community]=v3.5/community
    [v36]=v3.6/main
    [v36community]=v3.6/community
    [v37]=v3.7/main
    [v37community]=v3.7/community
    [v38]=v3.8/main
    [v38community]=v3.8/community
    [v39]=v3.9/main
    [v39community]=v3.9/community
    [v310]=v3.10/main
    [v310community]=v3.10/community
    [v311]=v3.11/main
    [v311community]=v3.11/community
    [v312]=v3.12/main
    [v312community]=v3.12/community
    [v313]=v3.13/main
    [v313community]=v3.13/community
    [v314]=v3.14/main
    [v314community]=v3.14/community
    [v315]=v3.15/main
    [v315community]=v3.15/community
    [v316]=v3.16/main
    [v316community]=v3.16/community
    [v317]=v3.17/main
    [v317community]=v3.17/community
)

declare -A repos=()

IFS=' ' read -ra pkgs <<< "$PACKAGES $DEV_PACKAGES"
for pkg in ${pkgs[@]}; do
    repo=${pkg#*@}

    if [[ ${#pkg} -gt ${#repo} ]]; then
        repos[$repo]=0
    fi
done

base="http://dl-cdn.alpinelinux.org/alpine/"

for key in ${!repos[@]};do
    if [[ ${#urls[$key]} -gt 0 ]]; then
        echo "@$key $base${urls[$key]}" >> /etc/apk/repositories;
    fi
done

apk --repositories-file /etc/apk/repositories --update --allow-untrusted \
    --initdb --no-cache --root $ROOTFS add $PACKAGES || exit 1

if [[ ! -z $DEV_PACKAGES ]]; then
    apk --repositories-file /etc/apk/repositories \
        --update add $DEV_PACKAGES || exit 1
fi

cp /etc/passwd $ROOTFS/etc/passwd
cp /etc/group $ROOTFS/etc/group

if [ -d /src ]; then
    export SRC=/src
fi

if [ -f /runner/entrypoint.sh ]; then
    chmod +x /runner/entrypoint.sh
    /runner/entrypoint.sh || exit 1
fi

rm -rf $ROOTFS/var/cache/apk/*
cd $ROOTFS
tar czvf ../build/rootfs.tar.gz .

exit 0
