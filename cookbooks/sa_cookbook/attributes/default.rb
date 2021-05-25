# Atributos servidores principales de speech analytic 
#Version speechanalytic

node.default["speechmatics_ip"]                              =  data_bag_item('speechanalytic', 'sa_config')['speechmatics_ip'] 
node.default["speechmatics_port"]                            =  data_bag_item('speechanalytic', 'sa_config')['speechmatics_port'] 
node.default["idatha_ip"]                                    =  data_bag_item('speechanalytic', 'sa_config')['idatha_ip'] 
node.default["idatha_http_port"]                             =  data_bag_item('speechanalytic', 'sa_config')['idatha_http_port'] 
node.default["idatha_ssh_port"]                              =  data_bag_item('speechanalytic', 'sa_config')['idatha_ssh_port'] 
node.default["ftp_port_diarization_convert"]                 =  data_bag_item('speechanalytic', 'sa_config')['ftp_port_diarization_convert'] 
node.default["ftp_user_diarization_convert"]                 =  data_bag_item('speechanalytic', 'sa_config')['ftp_user_diarization_convert'] 
node.default["ftp_password_diarization_convert"]             =  data_bag_item('speechanalytic', 'sa_config')['ftp_password_diarization_convert'] 
node.default["ftp_converter_app_path"]                       =  data_bag_item('speechanalytic', 'sa_config')['ftp_converter_app_path'] 
node.default["ftp_root_folder_diarization_convert"]          =  data_bag_item('speechanalytic', 'sa_config')['ftp_root_folder_diarization_convert'] 
node.default["ftp_upload_folder_diarization_convert"]        =  data_bag_item('speechanalytic', 'sa_config')['ftp_upload_folder_diarization_convert'] 
node.default["ftp_download_folder_diarization_convert"]      =  data_bag_item('speechanalytic', 'sa_config')['ftp_download_folder_diarization_convert'] 
node.default["ip_mw"]                                        =  data_bag_item('speechanalytic', 'sa_config')['ip_mw'] 
node.default["port_mw"]                                      =  data_bag_item('speechanalytic', 'sa_config')['port_mw'] 
node.default["ip_bd"]                                        =  data_bag_item('speechanalytic', 'sa_config')['ip_bd'] 
node.default["port_bd"]                                      =  data_bag_item('speechanalytic', 'sa_config')['port_bd'] 
node.default["bd_user"]                                      =  data_bag_item('speechanalytic', 'sa_config')['bd_user'] 
node.default["bd_pass"]                                      =  data_bag_item('speechanalytic', 'sa_config')['bd_pass'] 
node.default["ip_sql_i6"]                                    =  data_bag_item('speechanalytic', 'sa_config')['ip_sql_i6'] 
node.default["ip_i6"]                                        =  data_bag_item('speechanalytic', 'sa_config')['ip_i6'] 
node.default["casandra_port"]                                =  data_bag_item('speechanalytic', 'sa_config')['casandra_port'] 
node.default["dns_i6"]                                       =  data_bag_item('speechanalytic', 'sa_config')['dns_i6'] 
node.default["user_api_i6"]                                  =  data_bag_item('speechanalytic', 'sa_config')['user_api_i6'] 
node.default["pass_api_i6"]                                  =  data_bag_item('speechanalytic', 'sa_config')['pass_api_i6'] 
node.default["i6_text_host"]                                 =  data_bag_item('speechanalytic', 'sa_config')['i6_text_host'] 
node.default["i6_text_port"]                                 =  data_bag_item('speechanalytic', 'sa_config')['i6_text_port'] 
node.default["http_binding_port"]                            =  data_bag_item('speechanalytic', 'sa_config')['http_binding_port'] 
node.default["centralized_api_base_url"]                     =  data_bag_item('speechanalytic', 'sa_config')['centralized_api_base_url'] 
node.default["sa_version"]                                   =  data_bag_item('speechanalytic', 'sa_config')['sa_version'] 
node.default["intermediate_version"]                         =  data_bag_item('speechanalytic', 'sa_config')['intermediate_version'] 

=begin
#modificar tipo a privada, publica o interxion para asignar ips correspondientes speechmatics e idatha
node.default["speechmatics_conexion"]   = "privada"
node.default["speechmatics_ip_pub"]     = "38.132.207.239"
node.default["speechmatics_ip_priv"]    = "172.16.219.3"
node.default["speechmatics_ip_interxion"] = "10.160.30.130"
node.default["speechmatics_port"]         = "8082"


node.default["idatha_conexion"]         = "privada"
node.default["idatha_ip_pub"]           = "38.132.204.106"
node.default["idatha_ip_priv"]          = "10.2.11.10"
node.default["idatha_port"]             = "9201"

node.default["billing_ip_pub"]          = "38.132.207.229"
node.default["billing_ip_priv"]         = "172.16.234.2"
node.default["billing_port"]            = "443"
node.default["billing_dns"]             = "billing-sq.inconcertcc.com/"


# Atributos de Integracion Middleware Allegro, Base Datos , OCC variables de speech analytic
# Allegro

node.default["ip_mw"]                   = "192.168.20.215"
node.default["ip_bd"]                   = "192.168.20.215"
node.default["bd_user"]                 = "usraccmw"
node.default["bd_pass"]                 = "inc2001"

# OCC

node.default["ip_sql_i6"]               = ""
node.default["ip_i6"]                   = ""
node.default["port_i6"]                 = "9160"
node.default["dns_i6"]                  = ""
node.default["user_api_i6"]             = "integrationsq"
node.default["ass_api_i6"]              = "inc0nc3rt"
node.default["i6_text_host"]            = ""
node.default["i6_text_port"]            = "9080"

=end
