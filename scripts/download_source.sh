#!/bin/sh

# mirror base url
base_url=https://hkg.mirror.rackspace.com/slackware/slackware64-14.2/source
base_path=./source
mkdir -p ${base_path}

## lrwxrwxrwx   1 root root         6 2010-08-12 00:48 ./n/imapd -> alpine
## drwxr-xr-x   2 root root      4096 2015-01-20 17:52 ./n/alpine
## -rw-r--r--   1 root root   4841816 2015-01-18 07:32 ./n/alpine/alpine-2.20.tar.xz

## (flag)(uperm)(gperm)(operm) 1 root root 6 2010-08-12 00:48 file -> target
## l -> ln -sf $target $file_path
## d -> mkdir -p $file_path
## - -> wget -q -O $file_path $file_url

# awk 'BEGIN{ FS="\t" } { printf("%s_%s.fastq.gz\n%s\n", $1, $2, $8) }' input |
# xargs -r -d '\n' -n 2 -- wget -O

## start
awk '$1 ~ /^[dl-][rwx-][rwx-][rwx-]/{ printf("%s\t%s\t%s\n", $1, $8, $10) }' FILE_LIST |
while IFS=$'\t' read -r perm file target; do
    # wget -O "$filename" -- "$url"
    file_url=${base_url}${file:1}
    file_path=${base_path}${file:1}
    flag=${perm:0:1}
    uperm=${perm:1:3}
    gperm=${perm:4:3}
    operm=${perm:7:3}
    echo ${flag} ${uperm} ${gperm} ${operm} ${file_url} ${file_path} ${target}
    case $flag in
        '-')
            file_path_dir=$(dirname $file_path)
            mkdir -p $file_path_dir
            wget -q -O $file_path $file_url
            chmod u=${uperm},g=${gperm},o=${operm} $file_path
            ;;
        'd')
            mkdir -p $file_path
            chmod u=${uperm},g=${gperm},o=${operm} $file_path
            ;;
        'l')
            file_path_dir=$(dirname $file_path)
            mkdir -p $file_path_dir
            ln -sf $target $file_path
            # chmod u=${uperm},g=${gperm},o=${operm} $file_path
            ;;
        *)
            echo invalid flag: $flag
            ;;
    esac
done
