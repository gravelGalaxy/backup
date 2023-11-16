问题：虚拟机中，挂载到根目录的分区空间不够了
解决方案：
1. 通过虚拟设备管理给虚拟机足够的磁盘空间。
2. 通过`sudo fdisk -l /dev/sda`，可以看到提示`GPT PMBR size mismatch will be corrected by write`错误，通过`sudo parted -l`之后`Fix`解决。
```
cs144@vm:~$ sudo fdisk -l /dev/sda
[sudo] password for cs144: 
GPT PMBR size mismatch (20971519 != 41943039) will be corrected by write.
The backup GPT table is not on the end of the device.
Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 864409E8-FEDC-4E44-B57B-302B291A9A18

Device     Start      End  Sectors Size Type
/dev/sda1   2048     4095     2048   1M BIOS boot
/dev/sda2   4096 20969471 20965376  10G Linux filesystem
```

```
cs144@vm:~$ sudo parted -l
Warning: Not all of the space available to /dev/sda appears to be used, you can
fix the GPT to use all of the space (an extra 20971520 blocks) or continue with
the current setting? 
Fix/Ignore? Fix                                                           
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  2097kB  1049kB                     bios_grub
 2      2097kB  10.7GB  10.7GB  ext4
```

3. 然后再次执行`sudo fdisk -l /dev/sda`可以看到磁盘空间容量增加。
```
cs144@vm:~$ sudo fdisk -l /dev/sda
Disk /dev/sda: 20 GiB, 21474836480 bytes, 41943040 sectors
Disk model: VBOX HARDDISK   
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 864409E8-FEDC-4E44-B57B-302B291A9A18

Device     Start      End  Sectors Size Type
/dev/sda1   2048     4095     2048   1M BIOS boot
/dev/sda2   4096 20969471 20965376  10G Linux filesystem
```
4. 使用`sudo parted /dev/sda resizepart <index> <target_size>`来扩容,其中`index`是想要扩容的`/dev/sda`磁盘上的分区，`target_size`是想要扩容到的大小。
```
cs144@vm:/home$ sudo parted /dev/sda print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  2097kB  1049kB                     bios_grub
 2      2097kB  10.7GB  10.7GB  ext4
```
```
cs144@vm:/home$ sudo parted /dev/sda resizepart 2 15GB
Warning: Partition /dev/sda2 is being used. Are you sure you want to continue?
Yes/No? yes                                                               
Information: You may need to update /etc/fstab.
```

5. 调整分区大小后，需要更新文件系统来反应更改。如果分区使用ext2/3/4文件系统，可以使用`sudo resize2fs /dev/sda2`命令。
```
cs144@vm:/home$ sudo parted /dev/sda print
Model: ATA VBOX HARDDISK (scsi)
Disk /dev/sda: 21.5GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  2097kB  1049kB                     bios_grub
 2      2097kB  15.0GB  15.0GB  ext4
```
```
cs144@vm:/home$ sudo resize2fs /dev/sda2
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/sda2 is mounted on /; on-line resizing required
old_desc_blocks = 2, new_desc_blocks = 2
The filesystem on /dev/sda2 is now 3661597 (4k) blocks long.
```
6. 通过`df -h`发现分区成功扩容
```
cs144@vm:/home$ df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           393M  1.1M  392M   1% /run
/dev/sda2        14G  9.2G  3.8G  71% /
tmpfs           2.0G     0  2.0G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           393M  4.0K  393M   1% /run/user/1000
```
