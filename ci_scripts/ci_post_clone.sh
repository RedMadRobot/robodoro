#!/bin/sh

cd ..

brew install xcodegen
brew install swiftgen

xcodegen

xcodebuild -resolvePackageDependencies