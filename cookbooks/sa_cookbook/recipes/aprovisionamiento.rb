
 include_recipe 'tar' 
#Ruby function to check directory or file existence

      package 'Install Node' do        
        package_name 'nodejs'          
        only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
      end
        
     
      #Actualizar paquetes
      apt_update 'all platforms' do
          frequency 86400
          action :periodic
          
      end

      #Instalar Unrar, build essential y tcl

      package 'Install Unrar' do
          package_name 'unrar'
          only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}               
      end
       

      package 'Install essential' do
          package_name 'build-essential'
          only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}            
      end

      package 'tcl' do
        package_name 'tcl'
        only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}    
      end

      #Instalar e iniciar redis
      package 'redis-server' do
        package_name 'redis-server'
        only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
      end


      bash 'enable and start redis' do
        
        code <<-EOL
        
        sudo systemctl enable redis-server.service
        sudo systemctl start redis-server.service 
        
        EOL
        only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
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
       only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
      end

      #Instalar sshpass
      package 'sshpass' do
        package_name 'sshpass'
        only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}      
      end


