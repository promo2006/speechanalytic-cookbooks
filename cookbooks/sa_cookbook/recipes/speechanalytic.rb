

#Instalación de speechanalytics
#crear carpetas necesarias 

if (node.default["speechmatic_flag"] =="true" && node.default["idatha_flag"] =="true" && node.default["billing_flag"] =="true")
  bash 'crear carpetas y detener pm2' do
    code <<-EOL
    mkdir -p /var/www/speechanalytic    
    mkdir -p /sq/storage/completed
    mkdir -p /sq/storage/out   

    EOL
  end
  #descargar y descomprimir ultimo build de speech analytics
  #sa_version = data_bag_item('speechanalytic', 'sa_config')['sa_version']
  sa_version = node.default["sa_version"]
  tar_extract "http://packages.i6.inconcertcc.com/speechanalytics/speech/SQ_#{sa_version}/speech-analytic-testing_#{sa_version}.tar.gz" do
    target_dir '/var/www/speechanalytic'
    creates '/tmp/speechanalytic/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
  end


  execute "npm install at /var/www/speechanalytic" do
    cwd '/var/www/speechanalytic'
    command 'npm install'
  end 

  # Instancias pm2 
  bash 'crear las instancias de node mediante el servicio pm2' do
  code <<-EOL
      
      pm2 start /var/www/speechanalytic/app.server.js --name speech-analytic -i 10
      pm2 startup
      pm2 save
    
      EOL
      
  end
  


  #Modificar archivos configuracion speechanalytic
  #Modificar archivo config.js en /var/www/speechaanlytic/server/config
  
    
  template '/var/www/speechanalytic/server/config/config.js' do
    source 'config.js.erb'  
  end

  #Modificar archivo integration.js en /var/www/speechaanlytic/server/config

    
  template '/var/www/speechanalytic/server/config/integration.js' do
    source 'integration.js.erb'  
  end


    
  #En este punto si la integracion es con i6 se debe hacer modificaciones iptables en el servidor de i6
  #Modificar archivo mssql.config.js en var/www/speechaanlytic/server/config
  template '/var/www/speechanalytic/server/config/mssql.config.js' do
    source 'mssql.config.js.erb'  
  end

  #Modificar archivo server.config.js en var/www/speechaanlytic/server/config
  template '/var/www/speechanalytic/server/config/server.config.js' do
    source 'server.config.js.erb'  
  end

  #Modificar archivo knex.config.js en var/www/speechanalytic/server/db/external/
  template '/var/www/speechanalytic/server/db/external/knex.config.js' do
    source 'knex.config.js.erb'  
  end

  #A continuacion  descargar y descomprimir intermediate-component 
  # Crear carpetas para descarga
  # Extraer en carpeta creada en el paso anterior 
  intermediate_version = node.default["intermediate_version"]
  tar_extract "http://packages.i6.inconcertcc.com/speechanalytics/utils/intermediate-component-sa_#{intermediate_version}.tar.gz" do
    target_dir '/tmp/intermediate-component-sa'
    creates '/tmp/intermediate/mycode/lib'
    tar_flags [ '-P', '--strip-components 1' ]
  end

  #Reemplazar carpeta por la ya existente
  bash 'stop, restart and reload pm2' do
    code <<-EOL    
    cp -R /tmp/intermediate-component-sa/* /var/www/speechanalytic/node_modules/intermediate-component-sa/

    EOL
    
  end

  #Modificar archivo customRequest.js en var/www/speechanalytic/node_modules/intermediate-component-sa
  template '/var/www/speechanalytic/node_modules/intermediate-component-sa/server/customRequest.js' do
    source 'customRequest.js.erb'  
  end

  #Reiniciar y recargar pm2
  bash 'stop, restart and reload pm2' do
  code <<-EOL    
  pm2 stop all
  pm2 restart all
  pm2 reload all
  EOL

  end

  #Configurar archivo crontab
  cron 'speechcrontab' do
    minute '*/1'
    hour '*'
    day '*'
    month '*'
    weekday '*'
    command 'node /var/www/speechanalytic/server/task/speechanalytics.task.js'
    action :create
  end

  #Descargar paquetes media info

  #Actualizar paquetes
  apt_update 'all platforms' do
    frequency 86400
    action :periodic
  end
    
  package 'Install libmms0' do
    package_name 'libmms0'
  end
    
  bash 'Descargar paquetes necesarios para la diarizacion' do
  code <<-EOL
    cd /.
    wget https://mediaarea.net/download/binary/libzen0/0.4.38/libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb
    wget https://mediaarea.net/download/binary/libmediainfo0/20.09/libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb
    wget https://mediaarea.net/download/binary/mediainfo/20.09/mediainfo_20.09-1_amd64.xUbuntu_16.04.deb    
        
    EOL
  end
    
  dpkg_package 'libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb' do
    source '/libzen0v5_0.4.38-1_amd64.xUbuntu_16.04.deb'
    action :install
  end
    
  dpkg_package 'libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb' do
    source '/libmediainfo0v5_20.09-1_amd64.xUbuntu_16.04.deb'
    action :install
  end
    
  dpkg_package 'mediainfo_20.09-1_amd64.xUbuntu_16.04.deb' do
    source '/mediainfo_20.09-1_amd64.xUbuntu_16.04.deb'
    action :install
        
  end
  package 'Install ffmpeg' do
    package_name 'ffmpeg'
  end

  #wget -q http://#{node.inconcert.sources.server}/repo/curl_7_73_ubuntu.gz -O /tmp/curl_7_73_ubuntu.gz
  
end

