# Convert a VirtualBox .ova VM into a Vagrant box

Sometimes distribution providers (such as [UCS](https://www.univention.com/downloads/ucs-download/preinstalled-vm-images/download-vm-image/)) only give you VirtualBox `.ova` files to test their software. Here is how you can easily and non-interactively import a `.ova` file into a `.box` for use with Vagrant.

``` bash
$ VBoxManage import ./UCS-Virtualbox-Demo-Image.ova --vsys 0 --eula accept                                                                                                                                   
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Interpreting /home/crohr/dev/ucs/./UCS-Virtualbox-Demo-Image.ova...                                                                                                                       
OK.                                                                                                                                                                                                        
Disks:  vmdisk1 53687091200     -1      http://www.vmware.com/interfaces/specifications/vmdk.html#streamOptimized       UCS-Demo-Image-virtualbox-disk1.vmdk    -1      -1                                 
...
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Successfully imported the appliance.                           
```

Then list your VMs to find the VM ID:

``` bash
$ VBoxManage list vms
"UCS 4.1" {acef4c0a-35be-4640-a214-be135417f04d}
```

You can now package that VM as a Vagrant box:

``` bash
$ vagrant package --base acef4c0a-35be-4640-a214-be135417f04d --output UCS.box                                                                                                                             
==> acef4c0a-35be-4640-a214-be135417f04d: Exporting VM...                                                                                                                                                
==> acef4c0a-35be-4640-a214-be135417f04d: Compressing package to: /home/crohr/dev/ucs/UCS.box                                                                                           
```

And add it to the list of your local Vagrant boxes:

``` bash
$ vagrant box add UCS.box --name UCS
```

Finally, you can create a Vagrantfile to use this box:

``` ruby
Vagrant.configure("2") do |config|
  config.vm.box = "UCS"
  # ...
end
```

And `vagrant up`!
