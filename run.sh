#!/bin/sh
CUR_DIR=`pwd`
WORKING_DIR='/home/tacc/premium_demo'
cd $WORKING_DIR
Rscript test_full.R $1
cp summary_1_disc_9_cont_3.2.3.png $CUR_DIR/public/images/summary_1_disc_9_cont_3.2.3.png
