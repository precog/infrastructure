maintainer       "Precog"
maintainer_email "operations@precog.com"
license          "All rights reserved"
description      "Installs Jenkins"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

%w{monodev nodejs wintersmith rvm}.each do |cookbook|
  depends cookbook
end
