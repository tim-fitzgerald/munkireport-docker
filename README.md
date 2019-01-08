## Munkireport-php Docker 
This repo contains the Dockerfile needed to build an image of [Munkireport-php][1] with Nginx as the server infrastructure running it. 

### Requirements 
* `.conf` files for Nginx to use - examples provided in the `/confs/` directory. 
* A .env file that contains your Munkireport configuration
* A `/local/` directory that contains the users for your Munkireport instance. 

See the Munkireport documentation for further information on the above. 

### Build & Run
Build the container in the standard Docker way with `docker build . -t your_org/munkireport:release_tag`. Once built you can either keep it local if you are building on the same machine that will run it, or upload it to a Docker repo such as Dockerhub or AWS ECR. 

To run the container you just need to volume mount the .env file and `/local/` directory. 

```bash
docker run -dit -p 8080:80 -v /path/to/.env:/www/munkireport/.env -v /path/to/local/:/www/munkireport/local/ munkireport your_org/munkireport:release_tag 
```
### Notes
In my environment I am terminating SSL at an AWS load balancer - hence why I have no SSL configuration done here. I highly recommend enabling SSL for this application. 

[1]: https://github.com/munkireport/munkireport-php
