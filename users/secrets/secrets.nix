let
  alex_secrets_1_pub_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcjx2eseZ+yn/6m1yLrPfBtgzDDw7QNP38JIwFtqKM0";
  users = [ alex_secrets_1_pub_key ];
in {
  "alex_github_1.age".publicKeys = users;
}
