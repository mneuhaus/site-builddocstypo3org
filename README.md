Overview
========

This is the Cookbook used to deploy build.docs.typo3.org website

For the first installation, consider one good hour to walk through all the steps which will depend on the speed of your network along with the performance of your machine.
There will about 500 Mb to download which includes a virtual machine and the necessary packages.

Vagrant setup
=============

The Cookbook contains a Vagrant setup so that you can run in on your local machine

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

	# Get the source
	git clone https://github.com/TYPO3-cookbooks/site-builddocstypo3org.git DocsTypo3Org

	# Install Gem dependencies
	cd DocsTypo3Org

	# Fire up the Virtual Machine... this may take some time as it will download an empty VM box
	vagrant up

	# Provision the VM
	vagrant provision

	# Configure the Vagrantfile
	# Check possible options at the bottom of the file
	edit Vagrantfile

	# Once the machine is set up you can enter the virtual machine by using vagrant itself.
	vagrant ssh

	# Alternatively, you can access through ssh
	# The default username / password is vagrant / vagrant
	ssh vagrant@192.168.156.131

	# Configure /etc/hosts so that you can access the box from the host
	# The IP of the VM was defined in the Vagrant file
	sudo nano /etc/hosts
	192.168.188.130 build.docs.typo3.box

</pre>

The next step is to set up the application.


<pre>

  # On the host system
  cd build.docs.typo3.org

	# Time to play around with the application
	vagrant ssh
	sudo su - builddocstypo3org
	export FLOW_CONTEXT=Development/Vagrant
	cd /var/www/vhosts/build.docs.typo3.org/releases/current
	./flow help

	-> check the commands "document:*" exist

	# Update the Schema
	./flow doctrine:migrate

	# Prepare 10 documents from Git and 10 from TER
	# Notice argument "git" and "ter" are optional. If omitted, both TER and Git will be assumed
	./flow document:importall --limit 10 git
	./flow document:importall --limit 10 ter

	# Process the queue
	# Notice: normally this command should be run in another terminal within a screen
	./flow job:work git


	# Process the queue
	./flow queue:start
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
