# SHARING LOCAL FILES WITH CONTAINER
### START PROJECT EXAMPLE
1. Start container
```bash
docker run --name my_site -p 8080:80 -d httpd:2.4
```
2. Open the browser and access http://localhost:8080 or use the curl command to verify if it's working fine or not.
```bash
curl localhost:8080
```
### CREATE SHARING LOCAL FILES
1. Delete container
```bash
docker rm -f my_site
```
2. make directory
```bash
mkdir public_html
```
3. change dir to `public_html` and make file `html` with this
```html index.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title> My Website with a Whale & Docker!</title>
</head>
<body>
<h1>Whalecome!!</h1>
<p>Look! There's a friendly whale greeting you!</p>
<pre id="docker-art">
   ##         .
  ## ## ##        ==
 ## ## ## ## ##    ===
 /"""""""""""""""""\___/ ===
{                       /  ===-
\______ O           __/
\    \         __/
 \____\_______/

Hello from Docker!
</pre>
</body>
</html>
```
### RUN PROJECT WITH CONFIGURATION
```bash
MSYS_NO_PATHCONV=1 docker run --name my_site -p 8080:80 -v /c/public_html:/usr/local/apache2/htdocs/ -d httpd:2.4
```