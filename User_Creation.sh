#!/bin/bash
 declare -A USERKEY
 USERKEY[tom]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Tom's Public Key"
 USERKEY[Louis]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Louis's Public Key"
 USERKEY[Jenelly]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyFgGobmiU2H Jenally's Public Key"
 declare -A SUDOUSER
 SUDOUSER[tom]=y
 for user in "${!USERKEY[@]}" ; do
  adduser --disabled-password --gecos "" $user
   usermod -a -G adm $user

    if [ "${SUDOUSER[$user]}" == 'y' ] ; then
     usermod -a -G sudo $user
      echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
    fi

   mkdir /home/$user/.ssh 	
   echo "${USERKEY[$user]}" >> /home/$user/.ssh/authorized_keys
   chown -R $user:$user /home/$user/.ssh
   chmod -R go-rx /home/$user/.ssh
  done
