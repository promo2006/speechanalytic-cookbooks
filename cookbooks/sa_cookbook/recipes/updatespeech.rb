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
#Verificar si ya existe una instalacion en marcha

ruby_block "VerificaSpeechVersion" do
  block do
      #tricky way to load this Chef::Mixin::ShellOut utilities
      if File.exists?('/var/www/speechanalytic/package.json')  
          szversionI = node.default["sa_version"].size   
          Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
          command = 'grep version /var/www/speechanalytic/package.json'
          command_out = shell_out(command)
          #node.set['my_attribute'] = command_out.stdout
          version = command_out.stdout[14,szversionI]   
          #Chef::Log.fatal  version.size       
          
          if version != node.default["sa_version"]
            node.default["flagupdate"] = 'true'
            puts " Realizando upgrade de speechanalytic de la versión: " + version + " a la versión: " + node.default["sa_version"] 
          else
            node.default["flaginstall"] ='true'
          end
        else
        node.default["flaginstall"] ='true'        
      end
  end
  action :create
end

ruby_block "VerificaNodeVersion" do
    block do
        #tricky way to load this Chef::Mixin::ShellOut utilities
        if File.exists?('/var/www/speechanalytic/package.json') 
            Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)      
            command = 'node --version'
            command_out = shell_out(command)
            #node.set['my_attribute'] = command_out.stdout
            nodeversion = command_out.stdout  
            #Chef::Log.fatal  version.size       
            puts  nodeversion
            
            if nodeversion.start_with? "v8"
              node.default["updatenodeversion"] = 'true'
            end
        end
    end
    action :create
  end


  #Agregar entradas para instalacion de Node 

  if node.default["sa_version"][0,1].to_i >= 1
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
      
    
    else
      Chef::Log.fatal 'sa_speech v0 ubuntu20'
      Chef::Log.fatal 'No se puede instalar'
    end
  end

  bash 'preparar carpetas para el upgrade' do
    sa_bakupname =  "speechanalytic_#{Time.new.strftime("%Y%m%d")}"
    node.default["flaginstall"]='false'
    code <<-EOL 
       sudo mkdir -p /tmp/speechupdate/speechanalytic   
    EOL
    only_if {node.default["flagupdate"] == 'true'}
  end

  sa_version = node.default["sa_version"]
  sa_repository = node.default["sa_repository"] 
  if node.default["install_mode"] == 'production'
    route_install = "http://#{sa_repository}/speech/SQ_#{sa_version}/speech-analytic-testing_#{sa_version}.tar.gz"
  else
   
    route_install = "http://#{sa_repository}/speech-testing/SQ_#{sa_version}/speech-analytic-testing_#{sa_version}.tar.gz"
  end 
  
  tar_extract "#{route_install}" do
   
    target_dir '/tmp/speechupdate/speechanalytic'
    creates '/tmp/speechupdate/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
    only_if {node.default["flagupdate"] == 'true' }
  end

  
  execute "BackupInstallAntiguo" do 
    sa_bakupname =  "speechanalytic_#{Time.new.strftime("%Y%m%d")}"   
    command "cp -R /var/www/speechanalytic /var/www/#{sa_bakupname}"
    user "root"
    only_if {node.default["flagupdate"] == 'true' }
  end

  execute "CopiarArchivosNuevaInstalacion" do
    command "cp -R /tmp/speechupdate/speechanalytic/*  /var/www/speechanalytic/"
    user "root"
    only_if {node.default["flagupdate"] == 'true' }
  end  

  execute "CopiarConfigAntiguo" do
    sa_bakupname =  "speechanalytic_#{Time.new.strftime("%Y%m%d")}"
    command "cp -R /var/www/#{sa_bakupname}/server/config/* /var/www/speechanalytic/server/config/"
    user "root"
    only_if {node.default["flagupdate"] == 'true' }
  end

  execute "CopiarKnexAntiguo" do
    sa_bakupname =  "speechanalytic_#{Time.new.strftime("%Y%m%d")}"
    command "cp -R /var/www/#{sa_bakupname}/server/db/external/knex.config.js /var/www/speechanalytic/server/db/external/"
    user "root"
    only_if {node.default["flagupdate"] == 'true' }
  end
  
 

  apt_update 'all platforms' do
    frequency 86400
    action :periodic   
   end

 
    bash 'actualizar a node 14' do
    
    code <<-EOL  
   
    sudo apt-get install -y nodejs
    node -v
    npm install @types/socket.io@latest --save-dev [Última versión: ^3.0.2]
    npm install @types/socket.io-client@latest --save-dev [Última versión: ^3.0.0]
    npm install @types/socket.io-redis@latest --save-dev [Última versión: ^3.0.0]
    npm install socket.io@latest --save [Última versión: ^4.1.2]
    npm install socket.io-client@latest --save [Última versión: ^4.1.2]
    npm install "@socket.io/redis-adapter" --save [Última versión: ^7.0.0]
    npm uninstall socket.io-redis --save


    EOL
    only_if {node.default["flagupdate"] == 'true' && node.default["updatenodeversion"] =='true'}
    end

    # Extraer en carpeta creada en el paso anterior 
    intermediate_version = node.default["intermediate_version"]  
    tar_extract "http://#{sa_repository}/utils/intermediate-component-sa_#{intermediate_version}.tar.gz" do
    target_dir '/tmp/intermediate-component-sa'
    creates '/tmp/intermediate/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
    only_if {node.default["flagupdate"] == 'true' }  
   end

  #Reemplazar carpeta intermediate por la ya existente

  execute "CopiarNuevoIntermediate" do
    command "cp -R /tmp/intermediate-component-sa/* /var/www/speechanalytic/node_modules/intermediate-component-sa/"
    user "root"
    only_if {node.default["flagupdate"] == 'true' }
  end

  #Modificar archivo customRequest.js en var/www/speechanalytic/node_modules/intermediate-component-sa
  template '/var/www/speechanalytic/node_modules/intermediate-component-sa/server/customRequest.js' do
    source 'customRequest.js.erb'  
    only_if {node.default["flagupdate"] == 'true' }
  end

    

    


