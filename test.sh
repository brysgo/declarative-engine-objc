#!/bin/bash

xcodebuild   -workspace Example/declarative-engine.xcworkspace   -scheme declarative-engine-Example   -sdk iphonesimulator   -destination 'platform=iOS Simulator,name=iPhone XR,OS=12.1' test
