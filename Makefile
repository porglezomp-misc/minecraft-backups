main:
	@echo "Do 'make deploy' to upload"

deploy:
	aws s3 cp --acl public-read "site/index.html" "s3://minecraft.calebjones.net/index.html"
	aws s3 cp --acl public-read "site/css/styles.css" "s3://minecraft.calebjones.net/styles.css"
