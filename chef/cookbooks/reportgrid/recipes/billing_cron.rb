#
# Cookbook Name:: reportgrid
# Recipe:: billing_cron
#
# Copyright 2011, ReportGrid
#
# All rights reserved - Do Not Redistribute
#

cron "billing_assessment" do
  command "curl 'http://localhost:30040/accounts/credit/accounting?token=8E680858-329C-4F31-BEE3-2AD15FB67EED' -sS -H 'ReportGridDecrypter: 1' -H 'Content-Type: application/json' -d ''"
  user "reportgrid"
  minute "0"
  hour "5"
  mailto "operations@reportgrid.com"
end

#cron "billing_usage" do
#  command "curl 'http://localhost:30040/accounts/usage/accounting?token=8E680858-329C-4F31-BEE3-2AD15FB67EED' -v -H 'ReportGridDecrypter: 1' -H 'Content-Type: application/json' -d ''"
#  user "reportgrid"
#  minute "0"
#  hour "5"
#  mailto "operations@reportgrid.com"
#end
