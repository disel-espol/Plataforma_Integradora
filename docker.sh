#!/bin/bash

dos2unix ./tools/emulab-xmlrpc/*
dos2unix ./tools/bin/*
cd tools/bin
ln -sf ../emulab-xmlrpc/script_wrapper.py experimentManifests
ln -sf ../emulab-xmlrpc/script_wrapper.py experimentReboot
ln -sf ../emulab-xmlrpc/script_wrapper.py experimentStatus
ln -sf ../emulab-xmlrpc/script_wrapper.py extendExperiment
ln -sf ../emulab-xmlrpc/script_wrapper.py startExperiment
ln -sf ../emulab-xmlrpc/script_wrapper.py terminateExperiment