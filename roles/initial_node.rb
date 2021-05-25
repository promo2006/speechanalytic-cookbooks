name        "cluster_initial_node"
description "An speechanalytic cluster node"

run_list [ 
  "recipe[sa_cookbook::aprovisionamiento]",
  "recipe[sa_cookbook::speechanalytic]"
  #"role[keepalived_master_node]"
]


