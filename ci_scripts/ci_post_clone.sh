#!/bin/sh

cd ..

brew install xcodegen
brew install swiftgen

xcodegen

defaults delete com.apple.dt.Xcode IDEPackageOnlyUseVersionsFromResolvedFile
defaults delete com.apple.dt.Xcode IDEDisableAutomaticPackageResolution