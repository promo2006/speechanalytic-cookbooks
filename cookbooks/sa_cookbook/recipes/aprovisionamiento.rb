

# Instalar paquetes necesario para el funcionamiento de speechanalytics

include_recipe 'tar'
# Realizar Validaciones de conectividad node.default["speechmatics_ip"] node.default["speechmatics_port"]
speechmatics_ip = node.default["speechmatics_ip"]
speechmatics_port = node.default["speechmatics_port"]

ruby_block "check speechmatic" do
  block do
    server = speechmatics_ip
    port = speechmatics_port
    
    begin
      Timeout.timeout(5) do
        Socket.tcp(server, port){}       
      end
      node.default["speechmatic_flag"]  = "true"
      Chef::Log.info 'connections open'
      
    rescue
      Chef::Log.fatal 'connections refused'    
    end
    
  end
end

idatha_ip = node.default["idatha_ip"]  
idatha_ssh_port = node.default["idatha_ssh_port"] 

ruby_block "check idatha" do
  block do
    server = idatha_ip
    port = idatha_ssh_port
    
    begin
      Timeout.timeout(5) do
        Socket.tcp(server, port){}
        
      end
      node.default["idatha_flag"]  = "true"
      Chef::Log.info 'connections open'
      
    rescue
      Chef::Log.fatal 'connections refused'
      
    end
    
  end
end

billing_ip = node.default["billing_ip"]  
billing_port = node.default["billing_port"] 

ruby_block "check billing" do
  block do
    server = billing_ip
    port = billing_port
    
    begin
      Timeout.timeout(5) do
        Socket.tcp(server, port){}
        
      end
      node.default["billing_flag"]  = "true"
      Chef::Log.info 'connections open'
      
    rescue
      Chef::Log.fatal 'connections refused'
      
    end
   
  end
end

if (node.default["speechmatic_flag"] =="true" && node.default["idatha_flag"] =="true" && node.default["billing_flag"] =="true")
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
end 
