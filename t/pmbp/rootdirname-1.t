#!/bin/sh
echo "1..2"
basedir=`dirname $0`/../..
pmbp=$basedir/bin/pmbp.pl
tempdir=`perl -MFile::Temp=tempdir -e 'print tempdir'`/testapp

(perl $pmbp --root-dir-name="$tempdir/abc/def" && echo "ok 1") || echo "not ok 1"

(ls "$tempdir/abc/def" > /dev/null && echo "ok 2") || echo "not ok 2"

rm -fr $tempdir
