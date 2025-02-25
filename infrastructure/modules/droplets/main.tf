resource "digitalocean_droplet" "nodes" {
  count    = 1
  name     = var.name
  region   = var.region
  size     = var.vmsize
  image    = "ubuntu-22-04-x64"
  ssh_keys = [var.sshkey]
  tags     = var.tags
  
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa_deployer")
      host        = self.ipv4_address
    }

    inline = [
      "adduser --disabled-password --gecos '' deployer",
      "mkdir -p /home/deployer/.ssh",
      "cp /root/.ssh/authorized_keys /home/deployer/.ssh/authorized_keys",
      "chown -R deployer:deployer /home/deployer/.ssh",
      "chmod 700 /home/deployer/.ssh",
      "chmod 600 /home/deployer/.ssh/authorized_keys",
      "echo 'deployer ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers",
      "sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config",
      "sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config",
      "systemctl restart sshd",

      "while [ ! -e /dev/disk/by-id/scsi-0DO_Volume_${var.name}-data-storage ]; do echo 'waiting volume...'; sleep 2; done",
      "if [ -z \"$(blkid /dev/disk/by-id/scsi-0DO_Volume_${var.name}-data-storage)\" ]; then mkfs.ext4 /dev/disk/by-id/scsi-0DO_Volume_${var.name}-data-storage; fi",
      "mkdir -p /mnt/data_storage",
      "mount /dev/disk/by-id/scsi-0DO_Volume_${var.name}-data-storage /mnt/data_storage",
      "UUID=$(blkid -s UUID -o value /dev/disk/by-id/scsi-0DO_Volume_${var.name}-data-storage) && echo \"UUID=$UUID /mnt/volume ext4 defaults,nofail 0 2\" >> /etc/fstab",
    ]
  }
}

resource "digitalocean_volume" "data_storage" {
  name   = "${var.name}-data-storage"
  region = var.region
  size   = var.volumesize
}

resource "digitalocean_volume_attachment" "attach_volume" {
  droplet_id = digitalocean_droplet.nodes[0].id
  volume_id  = digitalocean_volume.data_storage.id
  depends_on = [digitalocean_droplet.nodes, digitalocean_volume.data_storage]
}