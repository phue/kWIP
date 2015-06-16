#!/bin/bash

set -e

cli=bin/kmerclust
all_kernels="d2 d2ent d2pop d2thresh d2freq js"

tmpdir=${TMPDIR:-/tmp}/$RANDOM-kmerclust-tests
mkdir $tmpdir
trap "echo rm -rf $tmpdir" EXIT

### Test all kernels with emtpy hashes, default params
for kernel in $all_kernels
do
	tst=empty-default-$kernel-$RANDOM
	out=$tmpdir/${tst}.out
	err=$tmpdir/${tst}.err
	set -x
	$cli $kernel data/empty-[12].ct 2>&1 >$out | tee $err
	set +x

	out_expect=$tmpdir/${tst}_expect.out
	cat > $out_expect << END
.	empty-1	empty-2
empty-1	-nan	-nan
empty-2	-nan	-nan
END
	diff $out $out_expect
done