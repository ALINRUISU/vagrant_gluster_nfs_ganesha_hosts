# vagrant_gluster_nfs_ganesha_hosts

# To Do
* Add /dev/sdb - done
* Update bootstrap.sh - done

# Gluster Design 
* 3 Nodes Replica using nfs ganesha
* 1 Node staging

# Test
* nfs ha
* Adding additional bricks
* Adding Expanding capacity
* Failover
* Failback

## Server
Adding the Server to a TSP
```console
    # gluster peer probe <server>
```

List the gluster pool
```console
    # gluster pool list
```

Check Peer Status
```console
    # gluster peer status
```

Removing a server
```console
   # gluster peer detach <server>
```

Geomaster vs replicated volumes
Replicated Volumes 	Geo-replication
Mirrors data across clusters -vs-	Mirrors data across geographically distributed clusters
Provides high-availability -vs-	Ensures backing up of data for disaster recovery
Synchronous replication (each and every file operation is sent across all the bricks) -vs-	Asynchronous replication (checks for the changes in files periodically and syncs them on detecting differences)


    Geo-replication over LAN
    Geo-replication over WAN
    Geo-replication over the Internet
    Multi-site cascading Geo-replication
   
Four Node Distributed Replicated Volume with a Two-way Mirror
```console
   # gluster volume create test-volume replica 2 transport tcp \
   glusterfs01:/srv/sdb1/brick \
   glusterfs02:/srv/sdb1/brick \
   glusterfs03:/srv/sdb1/brick \
   glusterfs04:/srv/sdb1/brick 
```
Start Volume
```console
   # gluster volume start <gluster volume name>
```

Volume Status
```console
   # gluster volume status <glusterfs volume name>
```

Volume Info
```console
   # gluster volume info
```


### Scaling 

Adding Gluster Volume 
```console
   # gluster peer probe <new gluster server name>
```

GluserFS add brick
```console
   # gluster volume add-brick examplevolume 192.168.2.105:/export
```

Gluster rebalance Volume
```console
   # gluster volume rebalance examplevolume start
```
Gluster rebalance Volume
```console
   # gluster volume rebalance examplevolume status
```

## Client
```console
   # yum --enablerepo=centos-gluster40 -y install glusterfs glusterfs-fuse 
```
```console
mount -t glusterfs node01.srv.world:/vol_distributed /mnt 
```

## Security
```console
   # gluster volume set testvol auth.allow 192.168.*.*
```
Please note that it is possible to use wildcards for the IP addresses (like 192.168.*) and that you can specify multiple IP addresses separated by comma (e.g. 192.168.0.104,192.168.0.105). 
