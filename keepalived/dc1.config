
! Configuration File for keepalived
global_defs {
   notification_email {
     xxxxxxx@domain.com	
   }
   notification_email_from {{ grains['id'] }}@domain.com
   smtp_server <<smtp host>>
   smtp_connect_timeout 30
   router_id TELEMETRY_PRCloud_LB
   vrrp_skip_check_adv_addr
   vrrp_garp_interval 0.001
   vrrp_gna_interval 0.0001
   vrrp_garp_master_delay 10
   vrrp_garp_master_refresh_repeat 2
}

vrrp_instance {{ grains['host'] }} {
 {% if "<<hostname1>>" in grains['host'] %}
    state MASTER
    priority 100
    unicast_src_ip <<ip1>>
    unicast_peer {                 # Unicast specific option, this is the IP of the peer instance 
     <<ip2>>
   }
 {% elif "<<hostname2>>" in grains['host'] %}
    state BACKUP
    priority 99
    unicast_src_ip <<ip2>>
    unicast_peer {                 # Unicast specific option, this is the IP of the peer instance 
     <<ip1>>
   }
 {% endif %}
    interface ens160
    virtual_router_id 51
    
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass tlmtry
    }
    virtual_ipaddress {
        <<vip1>>/24
    }
}

virtual_server <<vip1>> 514 {
    delay_loop 6
    lvs_method DR
    lvs_sched rr
    alpha 
    #persistence_timeout 10
    protocol UDP

    real_server <<backend_host_ip1>> 514 {
        weight 1
        TCP_CHECK {
    		connect_timeout 3
     		delay_before_retry 3
            }
        }


      real_server <<backend_host_ip2>> 514 {
        weight 1
        TCP_CHECK {
    		connect_timeout 3
    		delay_before_retry 3

            }

        }
    }

virtual_server <<vip1>> 5044 {
    delay_loop 6
    lvs_method DR
    lvs_sched rr
    alpha 
    #persistence_timeout 10
    protocol TCP

    real_server <<backend_host_ip1>> 5044 {
        weight 1
        TCP_CHECK {
        connect_port 22
    		connect_timeout 3
     		delay_before_retry 3
            }
        }


      real_server <<backend_host_ip2>> 5044 {
        weight 1
        TCP_CHECK {
        connect_port 22
    		connect_timeout 3
    		delay_before_retry 3

            }

        }
    }
