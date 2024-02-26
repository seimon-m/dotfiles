function mvf-create --description "Create movefile.yml in the current directory based on a template and user input"
    set -l movefile "movefile.yml"
    set -l movefile_path "$PWD/$movefile"
    set -l movefile_template "movefile.yml.template"
    set -l movefile_template_path "$HOME/.dotfiles/templates/$movefile_template"

    if not test -f $movefile_template_path
        echo "Template file not found: $movefile_template_path"
        return 1
    end

    if test -f $movefile_path
        echo "$movefile already exists."
        return 1
    end

    cp $movefile_template_path $movefile_path
    or return 1

    echo "Enter the following information:"

    echo "Production vhost: "
    read prod_vhost
    echo "Production wordpress_path: "
    read prod_wordpress_path
    echo "Production database name: "
    read prod_database_name
    echo "Production database user: "
    read prod_database_user
    echo "Production database password: "
    read prod_database_password
    echo "Production SSH host: "
    read prod_ssh_host

    set local_basename (basename $PWD)
    set local_vhost "https://$local_basename.test"
    set local_database_name $local_basename

    set replacements \
        "prod.vhost=$prod_vhost" \
        "prod.wordpress_path=$prod_wordpress_path" \
        "prod.database.name=$prod_database_name" \
        "prod.database.user=$prod_database_user" \
        "prod.database.password=$prod_database_password" \
        "prod.ssh.host=$prod_ssh_host" \
        "local.vhost=$local_vhost" \
        "local.wordpress_path=$PWD" \
        "local.database.name=$local_database_name" \
        "local.database.user=$USER"

    for replacement in $replacements
        set key (echo $replacement | cut -d= -f1)
        set value (echo $replacement | cut -d= -f2-)
        sed -i '' "s|$key|$value|g" $movefile_path
        or return 1
    end

    echo "Created $movefile."
end
