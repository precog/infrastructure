#
# Cookbook Name:: openssh
# Recipe:: roundhousesupport
#
# Copyright 2010, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

# Note: https://help.roundhousesupport.com/wiki/ssh-key-installation
ssh_authorized_key "roundhousesupport" do
  key_type "ssh-rsa"
  key "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA9Fz5ZQBOAALIlfZnkDE93OlX5DuQqKVIlIB4qf9yjcl5KFXZYA4ybJPS7T9jB0p3UGHORs7z0E93I3Wih5hEDsKOWhegf+qkJOd2bo9CM74mteDHhlJ3puMfyU/4pfulscqKj97LDUgT2YPyvix7qclnbx+tuHwKKJtYZ2k9rZYQ8mVh6CPReR/uXIxXlA0HahD7Gu53jRlopqvuGQBiDa9gExLeJkJx+PIdSq9f1cC/uRYc1K2m4+NScCm5AXoSa+TqaFEJrA7AAowpJC4cbiDzrA1wuDdF76/f0qCVn1Cszgb1uHSc1Q0+DvX4v23DtH7RThJ87+LyxqTAPF5cnw== access-control@roundhousesupport.com"
end
