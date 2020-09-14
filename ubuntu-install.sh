#!/bin/sh

inst=/usr/local/toyrouter
stage=.

[ "`whoami`" != "root" ] && echo "run install script as root" && exit 1

# ############################################################################
# clean
[ -d $inst ] || mkdir $inst
rm -fr $inst/*
mkdir $inst/bin
mkdir $inst/sbin
mkdir $inst/etc
mkdir $inst/etc/init.d
mkdir $inst/etc/www
mkdir $inst/etc/www/cgi-bin

# ############################################################################
# copy files from stage to target

copy_file () {
    file_name=$1
    source_dir=$2
    destination_dir=$3
    permissions=$4

    cp $source_dir/$file_name $destination_dir
    chmod $permissions $destination_dir/$file_name
}

copy_file ubuntu-pre-init.sh    $stage      $inst       u=rwx,g=rx,o=rx
copy_file busybox               $stage/bin  $inst/bin   u=rwx,g=rx,o=rx
copy_file inittab               $stage      $inst/etc   u=rw,g=r,o=r
copy_file inetd.conf            $stage      $inst/etc   u=rw,g=r,o=r
copy_file resolv.conf           $stage      $inst/etc   u=rw,g=r,o=r
copy_file udhcpd.conf           $stage      $inst/etc   u=rw,g=r,o=r
copy_file passwd                $stage      $inst/etc   u=rw,g=r,o=r
copy_file hostname              $stage      $inst/etc   u=rw,g=r,o=r
copy_file TZ                    $stage/bin  $inst/etc   u=rw,g=r,o=r
copy_file TZ.readme             $stage      $inst/etc   u=rw,g=r,o=r
copy_file wan-dhcp-event.sh     $stage      $inst/etc   u=rwx,g=rx,o=rx
copy_file wan-updown-event.sh   $stage      $inst/etc   u=rwx,g=rx,o=rx
copy_file lan-updown-event.sh   $stage      $inst/etc   u=rwx,g=rx,o=rx
copy_file iptables-rules.sh     $stage      $inst/etc   u=rwx,g=rx,o=rx
copy_file ddns-updater.sh       $stage      $inst/etc   u=rwx,g=rx,o=rx
copy_file index.cgi             $stage      $inst/etc/www/cgi-bin u=rwx,g=rx,o=rx

# ############################################################################
# create busybox symbolic links

for i in $($inst/bin/busybox --list)
do
    if [ "$i" != "busybox" ] ; then
        ln -s /usr/bin/busybox $inst/bin/$i
        ln -s /usr/bin/busybox $inst/sbin/$i
    fi
done

[ -f /var/lib/misc/udhcpd.leases ] || touch /var/lib/misc/udhcpd.leases

# ############################################################################
# add toyrouter to ubuntu boot menu

cat $stage/ubuntu-boot-menu-prepend >/etc/grub.d/15_toyrouter
cat /etc/grub.d/10_linux >>/etc/grub.d/15_toyrouter
chmod u=rwx,g=rx,o=rx /etc/grub.d/15_toyrouter

echo "run update-grub to update the boot menu"

