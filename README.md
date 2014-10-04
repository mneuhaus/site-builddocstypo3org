Overview
========

This is the Cookbook used to deploy build.docs.typo3.org website

Vagrant setup
=============

The Cookbook contains a Vagrant setup so that you can run in on your local machine.

For the first installation, consider one good hour to walk through all the steps which will depend on the speed of your network along with the performance of your machine.
There will about 500 Mb to download which includes a virtual machine and the necessary packages.

The first step is to create a VM and provision it.

<pre>

	# Prerequisite: VirtualBox must be > 4.3
	# Download from https://www.virtualbox.org/wiki/Downloads
	VirtualBox --help | grep VirtualBox

	# Prerequisite: vagrant must be > 1.5
	# Download from http://www.vagrantup.com/downloads.html
	vagrant --version

	# Install Vagrant plugin, will be asked anyway later.
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-omnibus
	vagrant plugin install vagrant-berkshelf

	# Fire up the Virtual Machine... this may take some time as it will download an empty VM box
	vagrant up

	# Provision the VM
	vagrant provision

	# Once the machine is set up you can enter the virtual machine by using vagrant itself.
	vagrant ssh

</pre>


Installation of the software
============================

Vagrant
-------

Vagrant can be downloaded and installed from the website http://www.vagrantup.com/downloads.html

Virtualbox
----------

VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use.
Follow this download link to install it on your system https://www.virtualbox.org/wiki/Downloads

Configure Vagrant file
----------------------

To adjust configuration open ``Vagrantfile`` file and change settings according to your needs.

<pre>
	# Define IP of the virtual machine to access it from the host
	config.vm.network :private_network, "192.168.188.130"

	# Turn on verbose Chef logging if necessary
	chef.log_level      = :debug
</pre>
