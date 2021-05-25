include_recipe 'line'

#configurar usuario
user 'admon' do
    comment '' 
    shell '/bin/bash'
    password 'HtM37WFwV37E6fy4'
  end

  #Agregar las siguientes lineas en sshd_config
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "Subsystem sftp /usr/lib/openssh/sftp-server"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "AllowUsers brt001spt admon"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "AllowTcpForwarding yes"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "MaxSessions 50"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "Protocol 2"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "LoginGraceTime 120"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "SyslogFacility AUTHPRIV"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "ClientAliveInterval 300"
  end
  append_if_no_line "Linea en sshd_config" do
    path "/etc/ssh/sshd_config"
    line "ClientAliveCountMax 0"
  end

   #Reemplazar Texto en .profile
   replace_or_add "profile" do
    path "/root/.profile"
    pattern "mesg n || true"
    line "tty -s && mesg n || true"
    replace_only true
  end

  append_if_no_line "Linea en sudoers" do
    path "/etc/sudoers"
    line "admon ALL=(ALL) NOPASSWD:ALL"
  end

  

  #Instalacion de rasa
  #Actualizar paquetes
  #add-apt-repository ppa:deadsnakes/ppa

  apt_repository 'add-apt' do
    uri          'ppa:deadsnakes/ppa'
  end
  

  apt_update 'all platforms' do
    frequency 86400
    action :periodic
  end
  package 'Install python3.6' do
    package_name 'python3.6'
  end
  package 'Install python3.6-dev' do
    package_name 'python3.6-dev'
  end

  bash 'update python3.5 to 3.6' do
    code <<-EOL
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5 1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 2
    update-alternatives --config python3
    EOL
  end

  apt_update 'all platforms' do
    frequency 86400
    action :periodic
  end

  package 'Install python3 pip' do
    package_name 'python3-dev'
  end

  package 'Install python3 pip' do
    package_name 'python3-pip'
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
  end

  package 'Install python3.6-gdbm' do
    package_name 'python3.6-gdbm'
  end
  

  
  #Prueba rasa
  bash 'Pruebarasa' do
    code <<-EOL
    
    mkdir -p /home/SimpleRasa/data
    mkdir -p /home/SimpleRasa/models
    
   
    EOL
  end

  template '/home/SimpleRasa/config.yml' do
    source 'config.yml.erb'  
  end
  
  
  template '/home/SimpleRasa/data/nlu.md' do
    source 'nlu.md.erb'  
  end
  
