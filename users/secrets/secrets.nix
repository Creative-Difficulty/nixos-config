let
  alex_secrets_1_pub_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMs14QkiUrbjYbmRQF2dzf25qVTuA5OICxwEg5tBR3vK";
  users = [ alex_secrets_1_pub_key ];
in
{
  "alex_github_1.age".publicKeys = users;
}
