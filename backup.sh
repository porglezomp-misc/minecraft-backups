while getopts q opt; do
    case $opt in
        q)
            QUIET=true
    esac
done

com () {
    mcrcon -s -H localhost -p peridot "$1"
}

say () {
    com "tellraw @a {\"text\":\"$1\",\"color\":\"gray\",\"italic\":true}"
    if [ -z ${QUIET+x} ]; then
        echo "$1"
    fi
}

dobackup () {
    zip -q -r latest.zip world/
}

upload () {
    name=$(TZ=America/Detroit date +%Y-%m-%dT%H-%M.zip)
    aws s3 cp --quiet --acl public-read "latest.zip" "s3://minecraft.calebjones.net/backups/$name"
    aws s3 cp --quiet --acl public-read "s3://minecraft.calebjones.net/backups/$name" "s3://minecraft.calebjones.net/backups/latest.zip"
    ./indexer.sh
}

say "Starting world backup..."
sleep 1 # Using sleep like this makes the process less unsettling in the server
com "save-off"
com "save-all"
say "Archiving backup..."
dobackup
say "Archive complete."
com "save-on"
sleep 1
say "Uploading backup..."
upload
say "Uploaded."
sleep 1
say "Backup complete."
sleep 1
com 'tellraw @a [{"text": "Download it at ","color": "gray","italic": true},{"text": "http://minecraft.calebjones.net/","color": "blue","underlined": true,"clickEvent": {"action": "open_url","value": "http://minecraft.calebjones.net/"}}]'

rm latest.zip
