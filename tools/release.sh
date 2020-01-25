#!/bin/sh

# Get the highest tag number
VERSION="$(git describe --abbrev=0 --tags)"
VERSION=${VERSION:-'v0.0.0'}

# Strip the v prefix
VERSION="$(echo "$VERSION" | sed -e 's/^v\(.*\)/\1/')"

# Get number parts
MAJOR="${VERSION%%.*}"
VERSION="${VERSION#*.}"
MINOR="${VERSION%%.*}"
VERSION="${VERSION#*.}"
PATCH="${VERSION%%.*}"
VERSION="${VERSION#*.}"

# Increase version
PATCH=$((PATCH + 1))

TAG="${1}"

if [ x"${TAG}" = x"" ]; then
  TAG="v${MAJOR}.${MINOR}.${PATCH}"
fi

echo "Releasing ${TAG} ..."

git tag -a -s -m "Release ${TAG}" "${TAG}"
git push --tags
