$Sample = Get-Random -Minimum -100 -Maximum 100
#$Sample2 = New-Guid
#echo $Sample2

docker build --pull --no-cache --rm -f "csv2mongo.dockerfile" -t csv2mongo:latest "."
docker run -i -t -d -p 27017:27017 --pid=host -v /var/lib/mysql --name mongo_container-$Sample csv2mongo:latest
docker inspect --format '{{ .NetworkSettings.IPAddress }}' mongo_container-$Sample