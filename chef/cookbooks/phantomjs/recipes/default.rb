#
# Cookbook Name:: phantomjs
# Recipe:: default
#
# Copyright 2011, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "build-essential"
include_recipe "git"
include_recipe "xvfb"

package "libqt4-dev"
package "qt4-qmake"
package "libpoppler-qt4-3"

# TODO: at some point parameterize the version
bash "phantomjs_from_source" do
  not_if "test -f /usr/local/bin/phantomjs"
  user "root"
  code <<-EOH
mkdir -p /opt/reportgrid/build && cd /opt/reportgrid/build
git clone git://github.com/ariya/phantomjs.git && cd phantomjs
git checkout 1.3
qmake-qt4 && make && cp bin/phantomjs /usr/local/bin
EOH
end
