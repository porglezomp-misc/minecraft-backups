cat > index.html <<- EOF
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Server Backups</title>
    <link href="/css/styles.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,900" rel="stylesheet">
  <head>
  <body>
    <h1>Server Backups</h1>
    <a href="/">Back</a>
    <p>Here are all the world file snapshots the server has taken.</p>
    <ul id="downloads">
EOF

files=$(aws s3 ls s3://minecraft.calebjones.net/backups/ | awk '{print $4}' | tac)
for file in $files; do
    if [ $file = "index.html" ]; then continue
    elif [ $file = "latest.zip" ]; then
        name="Latest"
    else
        date=$(echo $file | sed 's/\(.*\)T\(.*\)-\(.*\).zip/\1T\2:\3/')
        name=$(date --date=$date +"%B %d, %Y, at %I:%M %p")
    fi
# August 14, 2016, at 19:00
# 2016-08-14T19-00.zip
    cat >> index.html <<< "      <li><a href=\"https://s3.amazonaws.com/minecraft.calebjones.net/backups/$file\">$name</a></li>"
done

cat >> index.html <<- EOF
    </ul>
  </body>
</html>
EOF

aws s3 cp --quiet --acl public-read "index.html" "s3://minecraft.calebjones.net/backups/index.html"
rm index.html
