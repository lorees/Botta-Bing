# Created by Loree Sebastien 2/22/2023.
# Install cygwin on Windows 
clear;
echo "Before proceeding please check the time zone in the vagrantfile.";
echo "look for line: override.vm.provision 'shell', inline: "sudo timedatectl set-timezone America/New_York"";
echo "Confirm that this time zone is correct for your location.";
echo "If Not then update it with your correct timezone.";
echo "Check this list for time zones: https://gist.github.com/adamgen/3f2c30361296bbb45ada43d83c1ac4e5 .";

sleep 15;
cp -f Vagrantfile-Mac Vagrantfile;
vagrant up;
vagrant reload;
cat "instructions";

exit;
