[todo_servers]
todo_app_server ansible_host=${server_ip}

[todo_servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${ssh_key_path}
ansible_python_interpreter=/usr/bin/python3
domain_name=${domain_name}
github_repo_url=${github_repo_url}
app_directory=/home/ubuntu/app
