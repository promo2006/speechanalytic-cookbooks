file_cache_path "/tmp/chef-solo"
cookbook_path [ 
  "#{Dir.getwd}/cookbooks", 
  "#{Dir.getwd}/site-cookbooks",
  "/etc/inconcert/chef/site-cookbooks"
]
role_path "#{Dir.getwd}/roles"
local_databags_path = "/etc/inconcert/data_bags"
data_bag_path local_databags_path if File.exists? local_databags_path
 