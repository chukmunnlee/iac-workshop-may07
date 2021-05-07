import * as pulumi from "@pulumi/pulumi";
import * as digitalocean from "@pulumi/digitalocean";
import * as dotenv from 'dotenv'
import {readFileSync, writeFileSync} from "fs";
import {Region, DropletSlug} from "@pulumi/digitalocean";

dotenv.config()

const region = process.env.REGION as Region;

// create SSH key
// resource digitalocean_ssh_key mykey
const mykey = new digitalocean.SshKey('mykey', {
	publicKey: readFileSync('../mykey.pub').toString()
})

const myvolume = new digitalocean.Volume('myvolume', {
	region: region,
	size: parseInt(process.env.VOLUME_SIZE || '1'),
	initialFilesystemType: 'ext4'
})

const mydroplet = new digitalocean.Droplet('mydroplet', {
	region,
	image: process.env.DROPLET_IMAGE as string,
	size: process.env.DROPLET_SIZE as DropletSlug,
	sshKeys: [ mykey.fingerprint ],
	volumeIds: [ myvolume.id ],
	userData: readFileSync('./config.yaml').toString()
})

mydroplet.ipv4Address.apply(ipv4 => {
	writeFileSync(`root@${ipv4}`, '')
})

export const mydroplet_ipv4 = mydroplet.ipv4Address

/*
// Create a DigitalOcean resource (Domain)
const domain = new digitalocean.Domain("my-domain", {
  name: "my-domain.io"
});

// Export the name of the domain
export const domainName = domain.name;
*/
