# How to generate a self-signed certificate in non interactive mode

If you ever need to generate a self-signed SSL certificate automatically (i.e.
without any prompt or interactive questions), here is how you would do it:

    openssl genrsa -des3 -passout pass:p4ssw0rd -out server.pass.key 2048
    openssl rsa -passin pass:p4ssw0rd -in server.pass.key -out server.key
    rm server.pass.key
    openssl req -new -key server.key -out server.csr \
      -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

(adapted from [Heroku's procedure](https://devcenter.heroku.com/articles/ssl-certificate-self)).

Then, just use the generated `server.key` and `server.crt` files.
