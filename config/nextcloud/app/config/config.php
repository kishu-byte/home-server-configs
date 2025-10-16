<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => 'nextcloud-redis',
    'password' => '',
    'port' => 6379,
  ),
  'overwritehost' => 'nextcloud.fablebunker.com',
  'overwriteprotocol' => 'https',
  'upgrade.disable-web' => true,
  'passwordsalt' => 'jUmrfLSCYoVvEp3ZvN/uhmFnn9ZKa1',
  'secret' => 'z7zB7ougjk7+Ku3s1z6hlwwF4noM0hI1/SPXY5NlcjC6gpUS',
  'trusted_domains' => 
  array (
    0 => 'localhost',
    1 => 'nextcloud.fablebunker.com',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'mysql',
  'version' => '32.0.0.13',
  'overwrite.cli.url' => 'https://localhost',
  'dbname' => 'nextcloud',
  'dbhost' => 'nextcloud-db',
  'dbtableprefix' => 'oc_',
  'mysql.utf8mb4' => true,
  'dbuser' => 'homelab',
  'dbpassword' => 'fahSit-sokpet-depri9',
  'installed' => true,
  'instanceid' => 'octz7duqivzi',
);
