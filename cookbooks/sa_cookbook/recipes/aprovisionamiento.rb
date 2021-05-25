

# Instalar paquetes necesario para el funcionamiento de speechanalytics

include_recipe 'tar'


#Instalar Nodejs 8X
if node["platform"] == "ubuntu" && node["platform_version"] == "16.04"
    apt_repository 'nodejs' do
      uri 'https://deb.nodesource.com/node_8.x'
      distribution 'xenial'
      components ['main']
      key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
      action :add
    end

  
    package 'Install Node' do
      package_name 'nodejs'
    end


    #Actualizar paquetes
    apt_update 'all platforms' do
        frequency 86400
        action :periodic
      end

    #Instalar Unrar, build essential y tcl

    package 'Install Unrar' do
        package_name 'unrar'
    end

    package 'Install essential' do
        package_name 'build-essential'
    end

    package 'tcl' do
      package_name 'tcl'
    end

    #Instalar e iniciar redis
    package 'redis-server' do
      package_name 'redis-server'
    end


    bash 'enable and start redis' do
      
      code <<-EOL
      
      sudo systemctl enable redis-server.service
      sudo systemctl start redis-server.service 
      
      EOL
    end

    #Instalar pm2
    bash 'install pm2' do
      code <<-EOL
      sudo npm install pm2 -g  
      EOL
    end

    #Instalar sshpass
    package 'sshpass' do
      package_name 'sshpass'
    end

end
