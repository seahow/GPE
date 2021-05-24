#!/bin/bash
#
# deploy 2 general purpose environments, one on the east coast, one on the west.  make sure the CIDR blocks don't overlap because we will be bridging their networking
#
#

echo "creating stack in us-east-1.."
./pushgpe.sh --r us-east-1 --c "GPE v1.1a : east [10.1.10.0/24]" --i z1d.2xlarge --t Central --k l0-testing --b centralsa-labs --p gpe --n EAST --o suppress --x 10.1.10.0 --a byodatacenter.east --z EAST --y Aws2020@

echo "creating stack in us-west-2"
./pushgpe.sh --r us-west-2 --c "GPE v1.1a : west [10.1.11.0/24]" --i z1d.2xlarge --t Central --k l0-testing-oregon --b centralsa-labs --p gpe --n WEST --o suppress --x 10.1.11.0 --a byodatacenter.west --z WEST --y Aws2020@

echo "done"
