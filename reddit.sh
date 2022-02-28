#!/bin/bash
youtube-dl $(curl -s -H "User-agent: 'your bot 0.1'" https://www.reddit.com/r/TikTokCringe/top.json\?limit\=12 | jq '.' | grep url_overridden_by_dest | grep -Eoh "https:\/\/v\.redd\.it/\w{13}"
for f in *.mp4; do echo $f; done)


function ffmpeg-fill-blur()
{
  ffmpeg -i $1 \
    -vf 'split[original][copy];[copy]scale=ih*16/9:-1,crop=h=iw*9/16,gblur=sigma=20[blurred];[blurred][original]overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2' \
    $2
}

mkdir blur


for f in *.mp4; do ffmpeg-fill-blur $f ~/blur/$f; done

cd ~/blur
 
for f in *.mp4; do echo "file $f" >> fileList.txt; done
ffmpeg -f concat -i fileList.txt final.mp4

python2 upload_video.py --file="~/blur/final.mp4" --title="TikTok Trending Videos Compilation" --description="Had fun surfing in Santa Cruz" --keywords="TikTok,Trending,tiktok compilation" --category="22" --privacyStatus="public"
