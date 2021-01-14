dos2unix ./tools/emulab-xmlrpc/*
dos2unix ./tools/bin/*
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/experimentManifests
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/experimentReboot
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/experimentStatus
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/extendExperiment
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/startExperiment
ln -sf ./tools/emulab-xmlrpc/script_wrapper.py ./tools/bin/terminateExperiment

