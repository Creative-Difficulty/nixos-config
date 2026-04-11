let
  alex_secrets_1_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOhxfv6QZ6k3yFnE4feP019JI2IbO60AfNe3YDNJsZ9v";
  users = [ alex_secrets_1_pub_key ];
in
{
  "alex_github_1.age".publicKeys = users;
}
