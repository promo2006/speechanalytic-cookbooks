#
# Cookbook:: rasa_cookbook
# Recipe:: default
#
# Copyright:: 2021, The Authors, All Rights Reserved.
include_recipe 'line'
include_recipe 'openssl'

#configurar usuario
if node.default["flaginstall"]=='true' 
    Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

    password = 'HtM37WFwV37E6fy4'
    salt = random_password(length: 10)
    crypt_password = password.crypt("$6$#{salt}")

    
    user 'admon' do
      comment 'A random user'
      username 'admon'
      gid 'sudo'
      home '/home/admon'
      shell '/bin/bash'
      password crypt_password
     
    end

    #Agregar las siguientes lineas en sshd_config
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "Subsystem sftp /usr/lib/openssh/sftp-server"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end    

    replace_or_add "Setear Allowusers en config" do    
      path "/etc/ssh/sshd_config"
      pattern "AllowUsers brt001spt.*"
      line "AllowUsers brt001spt admon"
      replace_only true
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "AllowTcpForwarding yes"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "MaxSessions 50"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "Protocol 2"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "LoginGraceTime 120"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "SyslogFacility AUTHPRIV"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "ClientAliveInterval 300"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    append_if_no_line "Linea en sshd_config" do
      path "/etc/ssh/sshd_config"
      line "ClientAliveCountMax 0"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end



    #Reemplazar Texto en .profile
    replace_or_add "profile" do
      path "/root/.profile"
      pattern "mesg n || true"
      line "tty -s && mesg n || true"
      replace_only true
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    append_if_no_line "Linea en sudoers" do
      path "/etc/sudoers"
      line "admon ALL=(ALL) NOPASSWD:ALL"
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

      bash 'reiniciar ssh' do 
      code <<-EOL
      sudo systemctl restart ssh.service
      EOL
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    #Instalacion de rasa
    #Actualizar paquetes
    #add-apt-repository ppa:deadsnakes/ppa

    apt_repository 'add-apt' do
      uri          'ppa:deadsnakes/ppa'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    

    apt_update 'all platforms' do
      frequency 86400
      action :periodic 
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}      
    end
    package 'Install python3.6' do
      package_name 'python3.6'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    package 'Install python3.6-dev' do
      package_name 'python3.6-dev'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    bash 'update python3.5 to 3.6' do
      code <<-EOL
      update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
      update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
      update-alternatives --config python3
      EOL
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    apt_update 'all platforms' do
      frequency 86400
      action :periodic
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    package 'Install python3 pip' do
      package_name 'python3-dev'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    package 'Install python3 pip' do
      package_name 'python3-pip'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    

    bash 'python3 -m pip install pip 20.2' do
      code <<-EOL
      python3 -m pip install -U pip==20.2
      python3 -m pip install -U setuptools
      pip install gast==0.2.2
      pip install --user pytz==2019.1
      pip install tensorflow
      pip3 install rasa-x --extra-index-url https://pypi.rasa.com/simple   
      
    
      EOL
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    package 'Install python3.6-gdbm' do
      package_name 'python3.6-gdbm'
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    
    #Prueba rasa
    bash 'Pruebarasa' do
      code <<-EOL
      
      mkdir -p /home/SimpleRasa/data
      mkdir -p /home/SimpleRasa/models
      
    
      EOL
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end

    template '/home/SimpleRasa/config.yml' do
      source 'config.yml.erb' 
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
    
    
    template '/home/SimpleRasa/data/nlu.md' do
      source 'nlu.md.erb'  
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
    end
  end
