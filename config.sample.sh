##
## S3 Bucket
##
JAWS_BUCKET=${JAWS_BUCKET:="s3://example/"}

##
## CDN Paths
##   If desired, these can be the same. You might want them to be different to have different CloudFront settings
##
JAWS_STATICCDN=${JAWS_STATICCDN:="http://images.example.com/"}
JAWS_IMAGECDN=${JAWS_IMAGECDN:="http://images.example.com/"}

##
## The command used to generate your site.
##
JAWS_GENERATE=${JAWS_GENERATE:="jekyll build"}

##
## Max age cache settings
##
JAWS_LONGCACHE=2678400
JAWS_SHORTCACHE=86400

##
## Command to use to generate versions/timestamps on static content. If you're not using git, try the date one
##
## To use the git HEAD revision:
JAWS_REVISION=`git rev-parse HEAD`
## To use the current unix timestamp:
# JAWS_REVISION=`date +%s`

##
## Whether or not to use color in the output
##
## Use color:
JAWS_COLOR=1
## Don't use color:
# JAWS_COLOR=0

##
## gzip algorithm
##
## To use gzip's highest compression setting
JAWS_ZIPCMD="gzip -9 -n"
## To use zopfli (https://code.google.com/p/zopfli/) - better but slower
# JAWS_ZIPCMD=zopfli

##
## Echo out filenames that are being manipulated - Could get spammy with a large blog
##
JAWS_VERBOSE=${JAWS_VERBOSE:="1"}

##
## Set S3 object ACL to public
##
JAWS_ACL_PUBLIC=${JAWS_ACL_PUBLIC:=1}

