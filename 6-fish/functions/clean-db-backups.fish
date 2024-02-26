function clean-db-backups --description "Delete old wordmove database backups"
    set -l target_directory "~/repos/valet/*/wp-content"
    set -l files (find $target_directory -type f -mtime +30 -name "*-backup*.sql.gz" -or -name "*-backup*.sql")

    if set -q files[1]
        echo "The following files will be deleted:"
        for file in $files
            echo $file
        end
        echo "Do you want to continue? (y/N)"
        read -l confirm
        if test "$confirm" = "y" -o "$confirm" = "Y"
            for file in $files
                rm -v $file
            end
        else
            echo "Aborted."
        end
    else
        echo "No files to delete."
    end
end
