# Minecraft server systemd service
A multi-server service for systemd that utilizes GNU Screen to communicate with the server's console.
# Installation
#### Prerequisites
You would need to have this stuff already present in your system:
* GNU Bash or compatible shell.
* GNU Screen.
* A headless Java runtime.
* Obviously a server jar.
#### Creating a user
The script requires a user named _minecraft_ to exist in the system. The home directory must be _/srv/minecraft/_.  
**NOTE:** For some reason Screen refuses to run correctly if this user is using nologin/false instead of an actual shell: needs to be fixed.
```bash
sudo mkdir -p /srv/minecraft/
useradd -s /bin/bash -d /srv/minecraft/ minecraft
```
#### Creating Screen directory
```bash
sudo mkdir -p /srv/minecraft/screen/
```
#### Copying files
Only two files are required to be copied at their destinations:
1. **minecraft@.service** should be copied to _/etc/systemd/system/_
2. **service.sh** should be copied to _/srv/minecraft/_
3. **environment.conf** may be copied to _/srv/minecraft/servername/_

**NOTE:** the _service.sh_ script must also be executable:
```bash
sudo chmod +x /srv/minecraft/service.sh
```
#### Creating a new server
The server jar may be vanilla server or patched one - the script literally doesn't care about it. But the jar itself must be named as _/srv/minecraft/servername/server.jar_
1. Create a new directory
   ```bash
   sudo mkdir -p /opt/minecraft/servername/
   ```
2. Copy the server jar to it
   ```bash
   sudo cp whatever.jar /opt/minecraft/servername/server.jar
   ```
3. Start the server for the first time, letting the patched versions to patch themselves and create the eula.txt
   ```bash
   sudo systemctl start minecraft@servername
   ```
4. Accept the EULA by changing the **eula** property to **true**
   ```bash
   sudo vim /opt/minecraft/servername/eula.txt
   # ... some evil ViM actions go here, then :wq
   ```
4. Optionally modify the _server.properties_
   ```bash
   sudo vim /opt/minecraft/servername/server.properties
   # ... some evil ViM actions go here, then :wq
   ```
5. Make sure that the owner of **all** files in the directory is set to _minecraft_. Otherwise the server may fail to basically create some files and write logs to the disk.
   ```bash
   sudo chown -R minecraft /opt/minecraft/
   ```
6. Start and optionally enable the server service
   ```bash
   sudo systemctl start minecraft@servername
   sudo systemctl enable minecraft@servername
   ```
7. When you get tired, stop the service
   ```bash
   sudo systemctl stop minecraft@servername
   ```
# TODO
- [x] 30-second shutdown timeout that will force systemd to wait until the server is safely stopped instead of rude SIGTERM and non-successful return code
- [x] fix screen not being able to write to _/run/screens/_
- [ ] fix screen not being able to run when the shell is _/sbin/nologin_
- [ ] make screen to redirect standard output to the journal somehow
- [ ] probably use _title_ and _subtitle_ commands when the server is scheduled to stop.
- [ ] maybe add support for pre-run scripts so I can change MOTD every server restart without any third-party plugins that probably eat the already poor performance.
# Resources
I have been researching though a lot of projects to figure out why don't my script work as intended. I even tried to use tmux instead of screen but as it turns out, tmux refuses to work without a config or something so I considered using tmux as a _cringy_ way.  
So anyway, here's some useful resources:
* [minecraft-tmux-service](https://github.com/moonlight200/minecraft-tmux-service) which I tried to use, then gave up and wrote my script looking at this one from time to time to make sure I've done everything correctly
* [Minecraft Wiki](https://minecraft.gamepedia.com/Tutorials/Server_startup_script#Systemd_Script) because god has been dead for a long time
* [man systemd](https://www.freedesktop.org/software/systemd/man/), especially [systemd.exec](https://www.freedesktop.org/software/systemd/man/systemd.exec.html) and [systemd.service](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
