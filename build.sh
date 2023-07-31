#!/bin/sh
TRIK_STUDIO_VERSION_KIND=$1
DOCKER_HUB_USER=$2

assert_valid_tag() {
    case $TRIK_STUDIO_VERSION_KIND in
      "release");;
      "master");;
      *)
        echo "Incorrect TRIK studio version kind, available: master, release"
        exit 1
      ;;
    esac
}

create_name() {
  echo "$DOCKER_HUB_USER/trik-studio:$TRIK_STUDIO_VERSION_KIND-$1"
}

assert_valid_tag
docker build --no-cache --build-arg TRIK_STUDIO_VERSION_KIND="$TRIK_STUDIO_VERSION_KIND" ./docker

CURRENT_DOCKER_IMAGE_NAME=$(docker images -q | head -n 1)
RAW_VERSION=$(docker run --rm "$CURRENT_DOCKER_IMAGE_NAME" ./echo_version.sh)
NAME=$(create_name "$RAW_VERSION")

docker tag "$CURRENT_DOCKER_IMAGE_NAME" "$NAME"
