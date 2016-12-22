#! /bin/bash

expect -f rsync.expect $(cat ~/.pwd) "./IFS Files/nexus/nxds/" "/esdi/nexus/nexus_dev/NX31064/nexus/nxds/"

expect -f rsync.expect $(cat ~/.pwd) "./IFS Files/nexuspublic/nxds/" "/esdi/nexus/nexus_dev/NX31064/nexuspublic/nxds/"
