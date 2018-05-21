include:
    - .repo_installed
    - .default_mysql_uninstalled

mariadb_server_installed:
    pkg.installed:
        - pkgs:
            - MariaDB-client
            - MariaDB-server
        - require:
            - pkg: default_mysql_uninstalled
            - pkgrepo: repo_installed

root_user:
    mysql_user.present:
        - name: 'root'
        - password: '{{ pillar['mysql_root_pwd'] }}'
    
mysql remove anonymous users:
    mysql_user.absent:
        - name: ''
        - host: 'localhost'
        - connection_user: 'root'
        - connection_pass: '{{ pillar['mysql_root_pwd'] }}'
 
mysql remove test database:
    mysql_database.absent:
        - name: test
        - host: 'localhost'
        - connection_user: 'root'
        - connection_pass: '{{ pillar['mysql_root_pwd'] }}'
