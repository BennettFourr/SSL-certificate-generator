openssl genrsa -aes256 -out ca-key.pem 4096

openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca.pem

openssl genrsa -out cert-key.pem 4096

$cn = Read-Host "Enter Common Name (CN) value"

$command = "openssl req -new -sha256 -subj ""/CN=$cn"" -key cert-key.pem -out cert.csr"

Invoke-Expression $command

$dns = Read-Host "Enter DNS value"
$ip = Read-Host "Enter IP value"

$command = "echo ""subjectAltName=DNS:$dns,IP:$ip"" >> extfile.cnf"

Invoke-Expression $command

openssl x509 -req -sha256 -days 365 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial


openssl pkcs12 -export -out certificate.pfx -inkey cert-key.pem -in cert.pem

openssl x509 -outform der -in cert.pem -out cert.der

