name        "rasa_node"
description "An speechanalytic cluster node"

run_list [ 
  "recipe[rasa_cookbook::default]"  
  #"role[keepalived_master_node]"
]

