# Outland Docker

A docker image to host your own private TBC World of Warcraft server over a Zerotier network.

### Getting Started

Firsty get youself a free [Zerotier](https://www.zerotier.com/) account as this server will be hosted over a Zerotier network. Here is a good primer on [Zerotier](https://www.youtube.com/watch?v=Bl_Vau8wtgc) to show what we are aiming for. Once you have your account, set up a new Zerotier network and note the network id.

### Container Creation

With this config all files will be hosted within the container (suitable for most users)
```
docker run -d \ 
           -e ZT_NET=<network id> \
           --cap-add=NET_ADMIN \
           --cap-add=SYS_ADMIN \
           --device /dev/net/tun \
           --name=<container name> \
           nicktyrer/outland_docker
```

### Join the Zerotier Network

Once the container is running head back to the config page for your Zeroier network and authorise the container access to the network and then note down the containers IP address (In the managed IP's column).


### Add a GM Account

Attach to the container
```
docker exec -ti <container name> /bin/bash
````

Attach to the tmux session
```
sudo -u admin tmux a -t outland
```

```
account create <username> <password>
```

```
account set gmlevel <username> 6
```
detach from tmux using `ctrl+b then d` then `exit` to exit the container

### Management

To acces the MaNGOS console just connect via SSH using the Zerotier IP address

### Client config

People wanting to connect to the server will need three things:
1. Zerotier client with access to the Zerotier network
2. World of Warcraft 2.4.3 client (use the links [here](https://download.wowlibrary.com/tbc/TBC-2.4.3.8606-enGB-Repack.zip))
3. Edit realmlist.wtf in the Warcraft World of Warcraft 2.4.3 client to include `set realmlist <zerotier container ip>`

### Security

Take a look [here](https://blog.reconinfosec.com/locking-down-zerotier/) for how to restrict access to your container using Zerotiers network flow rules.


Thats it - [here](https://www.reaper-x.com/2007/09/21/wow-mangos-gm-game-master-commands/) are all of the gm commands to administer your server.

## Sources
[CMaNGOS](https://github.com/cmangos/)
