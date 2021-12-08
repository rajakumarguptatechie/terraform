sudo apt-get install apache2 -y	

sudo cat << EOF > /var/tmp/index.html
<!DOCTYPE html>
<html>
        <body>
                <h1> Terraform Training </h1>
                <p> This is to test Terraform provisioner by Raja Kumar Gupta </p>

        </body>
</html>
EOF

sudo cp /var/tmp/index.html /var/www/html/index.html
