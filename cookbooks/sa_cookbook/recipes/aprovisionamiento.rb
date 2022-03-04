# Instalar paquetes necesario para el funcionamiento de speechanalytics

include_recipe 'tar'

# Realizar Validaciones de conectividad a los servidores de speechmatic, idatha y billing
speechmatics_ip = node.default["speechmatics_ip"]
speechmatics_port = node.default["speechmatics_port"]

#if speechmatics_ip == ""
#  node.default["speechmatics_flag"] = 'true'
#end
ruby_block "check speechmatic" do
  block do
    server = speechmatics_ip
    port = speechmatics_port
    
    begin
      Timeout.timeout(5) do
        Socket.tcp(server, port){}       
      end
           
      puts " Se estableció conección correcta con el servidor de speechmatics"     
      node.default["speechmatics_flag"] = 'true'
    rescue
      Chef::Log.fatal 'No existe conección al servidor de speechmatics' 
      if server == ""
        node.default["speechmatics_flag"] = 'true'
        Chef::Log.fatal 'Ip servidor speechmatic en blanco' 
      end
       
    end
    
  end
end

idatha_ip = node.default["idatha_ip"]
idatha_port = node.default["idatha_http_port"]
#if idatha_ip == ""
#  node.default['idatha_flag'] = 'true' 
#end
ruby_block "check idatha" do
  block do
    server = idatha_ip
    port = idatha_port
    
    begin
      Timeout.timeout(5) do
        Socket.tcp(server, port){}       
      end
           
      puts " Se estableció conección correcta con el servidor de idatha"  
      node.default['idatha_flag'] = 'true'
    rescue
      Chef::Log.fatal 'No existe conección al servidor idatha'    
      if server == ""
        node.default['idatha_flag'] = 'true'
        Chef::Log.fatal 'Ip servidor idatha en blanco' 
      end
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
           
      puts " Se estableció conección correcta con el servidor de billing"
      node.default['billing_flag'] = 'true'
    rescue
      Chef::Log.fatal 'No existe conección al servidor de billing la instalación no se realizará '    
      
    end
    
  end
end



  #Instalar Nodejs 8X


  if node.default["sa_version"][0].to_i > 1
    if node["platform_version"] == "20.04" 
      distrib = 'focal'
    end
    if node["platform_version"] == "16.04" 
      distrib = 'xenial'
    end
    apt_repository 'nodejs' do
       
      uri 'https://deb.nodesource.com/node_14.x'
      distribution "#{distrib}"
      components ['main']
      key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
      action :add
      only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
    end
      Chef::Log.info 'sa_speech v1 ubuntu20'
      node.default["flaginstall"] ="true"
     
   
  else
    if node["platform_version"] == "16.04"
    
      apt_repository 'nodejs' do
       
        uri 'https://deb.nodesource.com/node_8.x'
        distribution 'xenial'
        components ['main']
        key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
        action :add
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
      end
      Chef::Log.info 'sa_speech v0 ubuntu16'
      node.default["flaginstall"] ="true"
    
    else
      Chef::Log.fatal 'sa_speech v0 ubuntu20'
      Chef::Log.fatal 'No se puede instalar'
    end
  end
 

  if node.default["flaginstall"]=='true'
      package 'Install Node' do        
        package_name 'nodejs'  
         
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}    
      end
        
     
      #Actualizar paquetes
      apt_update 'all platforms' do
          frequency 86400
          action :periodic
          only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end

      #Instalar Unrar, build essential y tcl

      package 'Install Unrar' do
          package_name 'unrar'
          only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end
       

      package 'Install essential' do
          package_name 'build-essential'
          only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end

      package 'tcl' do
        package_name 'tcl'
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end

      #Instalar e iniciar redis
      package 'redis-server' do
        package_name 'redis-server'
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end


      bash 'enable and start redis' do
        
        code <<-EOL
        
        sudo systemctl enable redis-server.service
        sudo systemctl start redis-server.service 
        
        EOL
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end

      #package 'install npm' do
       # package_name 'npm'
       # only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      #end

      #Instalar pm2
      bash 'install pm2' do
      code <<-EOL
      
      sudo npm install pm2 -g  
       EOL
       only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end

      #Instalar sshpass
      package 'sshpass' do
        package_name 'sshpass'
        only_if {node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}
      end


    end