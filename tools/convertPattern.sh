#/bin/bash
# Usage
# convertPattern.sh [opacity] [directory]

# convert iMage.png -matte -channel a -evaluate set 65% +channel newimage.png

# Please install imagemagik convert to continue...
opacity=$1
directory=$2
if [ -z $directory ]; then
	directory=`pwd`
fi
outdir=$directory-$opacity
basefile=`basename $outdir`
scss=$outdir.scss
htm=$outdir.html
cat << 'EOF' > $htm
<!DOCTYPE html>
<html>
    <head>
        <title>Patterns at opacity 25</title>
		<style>
			.pattern {
				float: left;
				padding: 15px;
				width: 30%;
				min-height: 5em;
			}
		</style>
EOF
echo "<link href="../css/$basefile.css" media=\"all\" rel=\"stylesheet\" type=\"text/css\" />" >> $htm
echo "</head><body>" >> $htm
rm -f $scss
mkdir -p $outdir

echo "Prepare to convert png images in $directory to opacity $opacity and save into $outdir";


for i in `ls $directory/*.png`; do
	j=`basename $i`;
	c=`basename $j .png`;
	echo -n "Processing file $j ...";
	o=$outdir/$j;
	img=`basename $outdir`/$j
	if [ ! -e $o ]; then
	    convert $i -verbose -matte -channel a -evaluate set $opacity% +channel $o;
    fi
    if [ -e $o ]; then
		echo ".$c { background-image: image-url(\"$img\"); }" >> $scss
		echo "<div class=\"$c pattern\"><p>$j</p></div>" >> $htm
	fi
    echo "Done";
done;

tidy -m $htm
