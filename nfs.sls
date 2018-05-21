install_nfs_utils:
 pkg.installed:
  - name: nfs-utils
  
/etc/fstab:
 file.append:
 {% if "<<minion name substring>>" in grains['id']  %}
  - text: |
      #Mount NFS in local datacenter
      <<mountpoint1>>	/mnt/configs		nfs  noatime,nfsvers=3,actimeo=1800,rsize=65535,wsize=65535,timeo=14,intr,tcp
  {% elif "<<minion name substring>>" in grains['id']  %}
  - text: |
      #Mount NFS in local datacenter
      <<mountpoint2>>	/mnt/configs	 nfs  noatime,nfsvers=3,actimeo=1800,rsize=65535,wsize=65535,timeo=14,intr,tcp
  {% endif %}   
   
/mnt/configs:
 file.directory
 
mount:
 cmd.run:
  - names:
     - mount -a
