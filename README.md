# Overview

Este repositorio contiene los directorios necesarios para la instalaciíon del sistema Speechanalytics y rasa a través de chef infra 
A continuación el detalle de los directorios con la descripcion de su funcionalidad

- `cookbooks/` - Contiene los cookbooks desarrollados los cuales son sa_cookbook que instala la herramienta speechanalytic junto a el software de aprovisionamiento necesario para el funcionamiento adecuado del sistema 
- `data_bags/` - Contiene las variables de configuracón de speechanalytic: como versión de speechanalytics e intermediate asi mismo ips y claves de los servidores de base de datos, middleware, I6, speechmatics, billing e idatha, estas variables deben ser asignadas antes de correr los cookbooks.
- `roles/` - Contiene el orden de instalación de los recipes de cada cookbook (run-list)
- `conf/` - Contiene el archivo solo.rb que contiene las rutas de configuracion de los databags


