# Parent Dockerfile https://github.com/docker-library/mongo/blob/982328582c74dd2f0a9c8c77b84006f291f974c3/3.0/Dockerfile
FROM mongo:latest

# Modify child mongo to use /data/db2 as dbpath (because /data/db wont persist the build)
#RUN mkdir -p /data/db2 \
#    && echo "dbpath = /data/db2" > /etc/mongodb.conf \
#    && chown -R mongodb:mongodb /data/db2
FROM mongo

RUN mkdir /myimportedcsv
COPY ./data/my.csv /myimportedcsv/casoscovid19.csv
#RUN mongoimport --host mongodb --db exampleDb --collection contacts --type json --file /myimportedcsv/casoscovid19.csv --jsonArray

#RUN mongoimport --host mongodb --db exampleDb --collection contacts --type csv  --file /myimportedcsv/casoscovid19.csv


#RUN echo "mongoimport mongodb --db exampleDb --collection contacts --type csv --headerline --drop /myimportedcsv/casoscovid19.csv" > /myimportedcsv/run.sh
#RUN echo "mongoimport -d mydb -c things --type csv --file /myimportedcsv/casoscovid19.csv --headerline" > /myimportedcsv/run.sh
#RUN echo 'mongo admin -u admin -p admin --eval "db.getSiblingDB(\'dummydb\').createUser({user: \'dummyuser\', pwd: \'dummysecret\', roles: [\'readWrite\'] } )"' > /myimportedcsv/run1.sh
RUN echo 'mongo --eval "db.getSiblingDB(\'dummydb\').createUser({user: \'dummyuser\', pwd: \'dummysecret\', roles: [\'readWrite\'] } )"' > /myimportedcsv/run1.sh
#RUN echo "mongoimport --db=users --type=csv --headerline --file=/myimportedcsv/casoscovid19.csv" > /myimportedcsv/run2.sh

RUN echo "mongoimport --db=users --type=csv --headerline --file=/myimportedcsv/casoscovid19.csv --ignoreBlanks" > /myimportedcsv/run2.sh
RUN cp /myimportedcsv/*.sh /docker-entrypoint-initdb.d/

#RUN mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db2 
#--smallfiles
    #&& CREATE_FILES=/data/db2/scripts/*-create.js \
    #&& for f in $CREATE_FILES; do mongo 127.0.0.1:27017 $f; done \
    #&& INSERT_FILES=/data/db2/scripts/*-insert.js \
    #&& for f in $INSERT_FILES; do mongo 127.0.0.1:27017 $f; done \
#RUN CSV_FILES=/data/db2/data/*.csv
#RUN for f in $CSV_FILES; do op=$(echo "$f" | cut -d"." -f 1) && mongoimport --type csv -d $op -c products --headerline --drop $f; done
#RUN mongod --dbpath /data/db2 --shutdown
#RUN chown -R mongodb /data/db2

# Make the new dir a VOLUME to persists it 
#VOLUME /data/db2

CMD ["mongod", "--config", "/etc/mongodb.conf"]