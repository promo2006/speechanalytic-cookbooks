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
node.default["billing_ip"]                                   =  data_bag_item('speechanalytic', 'sa_config')['billing_ip'] 
node.default["billing_port"]                                 =  data_bag_item('speechanalytic', 'sa_config')['billing_port'] 
node.default["install_mode"]                                 =  data_bag_item('speechanalytic', 'sa_config')['install_mode'] 
node.default["billing_flag"]                                 =  "false"
node.default["speechmatic_flag"]                             =  "false"
node.default["idatha_flag"]                                  =  "false"
node.default["sa_repository"]                                =  "packages.i6.inconcertcc.com/speechanalytics"
node.default["path_cron"]                                    =  {'PATH' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'}
node.default["flaginstall"]                                  =  "false"
node.default["flagupdate"]                                   =  "false"
node.default["updatenodeversion"]                            =  "false"
node.default["rasa_ip"]                                      =  data_bag_item('speechanalytic', 'sa_config')['rasa_ip'] 
node.default["rasa_port"]                                    =  data_bag_item('speechanalytic', 'sa_config')['rasa_port'] 




