

#Instalación de speechanalytics
#crear carpetas necesarias 

# Instalar paquetes necesario para el funcionamiento de speechanalytics

include_recipe 'tar'
include_recipe 'line'



  bash 'crear carpetas y detener pm2' do
    code <<-EOL
    mkdir -p /var/www/speechanalytic    
    mkdir -p /sq/storage/completed
    mkdir -p /sq/storage/out   

    EOL
    only_if {node.default["flaginstall"] == 'true'}  
  end
  #descargar y descomprimir ultimo build de speech analytics
  #sa_version = data_bag_item('speechanalytic', 'sa_config')['sa_version']
  sa_version = node.default["sa_version"]
  sa_repository = node.default["sa_repository"] 
  
  if node.default["install_mode"] == 'production'
    route_install = "http://#{sa_repository}/speech/SQ_#{sa_version}/speech-analytic-testing_#{sa_version}.tar.gz"
  else
   
    route_install = "http://#{sa_repository}/speech-testing/SQ_#{sa_version}/speech-analytic-testing_#{sa_version}.tar.gz"
  end 
  
  tar_extract "#{route_install}" do
    target_dir '/var/www/speechanalytic'
    creates '/tmp/speechanalytic/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}     
  end


  execute "npm install at /var/www/speechanalytic" do
    cwd '/var/www/speechanalytic'
    command 'npm install'
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
  end 

  # Instancias pm2 
  bash 'crear las instancias de node mediante el servicio pm2' do
  code <<-EOL
      
      pm2 start /var/www/speechanalytic/app.server.js --name speech-analytic -i 10
      pm2 startup
      pm2 save
    
      EOL
      only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
  end
  


  #Modificar archivos configuracion speechanalytic
  #Modificar archivo config.js en /var/www/speechaanlytic/server/config
  template '/var/www/speechanalytic/server/config/config.js' do
    source 'config.js.erb'  
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
  
  

  #Modificar archivo integration.js en /var/www/speechaanlytic/server/config

    
  template '/var/www/speechanalytic/server/config/integration.config.js' do
    source 'integration.config.js.erb'  
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
  end

    
  #En este punto si la integracion es con i6 se debe hacer modificaciones iptables en el servidor de i6
  #Modificar archivo mssql.config.js en var/www/speechaanlytic/server/config
  template '/var/www/speechanalytic/server/config/mssql.config.js' do
    source 'mssql.config.js.erb'  
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end

  #Modificar archivo server.config.js en var/www/speechaanlytic/server/config
  template '/var/www/speechanalytic/server/config/server.config.js' do
    source 'server.config.js.erb' 
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end

  #Modificar archivo knex.config.js en var/www/speechanalytic/server/db/external/
  template '/var/www/speechanalytic/server/db/external/knex.config.js' do
    source 'knex.config.js.erb'  
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}  
  end

  #A continuacion  descargar y descomprimir intermediate-component 
  # Crear carpetas para descarga
  # Extraer en carpeta creada en el paso anterior 
  intermediate_version = node.default["intermediate_version"]  
  tar_extract "http://#{sa_repository}/utils/intermediate-component-sa_#{intermediate_version}.tar.gz" do
    target_dir '/tmp/intermediate-component-sa'
    creates '/tmp/intermediate/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
  end

  #Reemplazar carpeta por la ya existente
  execute "CopiarNuevoIntermediate" do
    command "cp -R /tmp/intermediate-component-sa/* /var/www/speechanalytic/node_modules/intermediate-component-sa/"
    user "root"
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end

  #Modificar archivo customRequest.js en var/www/speechanalytic/node_modules/intermediate-component-sa
  template '/var/www/speechanalytic/node_modules/intermediate-component-sa/server/customRequest.js' do
    source 'customRequest.js.erb'  
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end

    
  #Reiniciar y recargar pm2
  bash 'stop, restart and reload pm2' do
  code <<-EOL    
  pm2 stop all
  pm2 restart all
  pm2 reload all
  EOL
  only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end

  #Configurar archivo crontab
  cron 'speechcrontab' do
    minute '*/1'
    hour '*'
    day '*'
    month '*'
    weekday '*'
    command 'node /var/www/speechanalytic/server/task/speechanalytics.task.js'
    environment node.default["path_cron"]
    action :create
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end


  #Descargar paquetes media info

  #Actualizar paquetes
  apt_update 'all platforms' do
    frequency 86400
    action :periodic
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
    
  package 'Install libmms0' do
    package_name 'libmms0'
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
    
  bash 'Descargar paquetes necesarios para la diarizacion' do

  code <<-EOL
    cd /.
    wget http://#{sa_repository}/utils/libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb
    wget http://#{sa_repository}/utils/libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb
    wget http://#{sa_repository}/utils/mediainfo_20.09-1_amd64.xUbuntu_16.04.deb    
        
    EOL
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
    
  dpkg_package 'libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb' do
    source '/libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb'
    action :install
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
    
  dpkg_package 'libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb' do
    source '/libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb'
    action :install
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end
    
  dpkg_package 'mediainfo_20.09-1_amd64.xUbuntu_16.04.deb' do
    source '/mediainfo_20.09-1_amd64.xUbuntu_16.04.deb'
    action :install    
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'}   
  end
  package 'Install ffmpeg' do
    puts "Instalación de SpeechAnalytic Finalizada Correctamente"
    package_name 'ffmpeg'
    only_if {node.default["flaginstall"] == 'true' && node.default["speechmatics_flag"] == 'true' &&  node.default['idatha_flag'] == 'true' && node.default['billing_flag'] == 'true'} 
  end




