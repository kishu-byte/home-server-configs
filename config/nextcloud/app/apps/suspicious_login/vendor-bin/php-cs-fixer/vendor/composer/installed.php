<?php return array(
    'root' => array(
        'name' => '__root__',
        'pretty_version' => 'dev-stable32',
        'version' => 'dev-stable32',
        'reference' => '2ce2a06e1aef3b3ab2dbc999355f7a6d97de6787',
        'type' => 'library',
        'install_path' => __DIR__ . '/../../',
        'aliases' => array(),
        'dev' => true,
    ),
    'versions' => array(
        '__root__' => array(
            'pretty_version' => 'dev-stable32',
            'version' => 'dev-stable32',
            'reference' => '2ce2a06e1aef3b3ab2dbc999355f7a6d97de6787',
            'type' => 'library',
            'install_path' => __DIR__ . '/../../',
            'aliases' => array(),
            'dev_requirement' => false,
        ),
        'friendsofphp/php-cs-fixer' => array(
            'dev_requirement' => true,
            'replaced' => array(
                0 => 'v3.62.0',
            ),
        ),
        'nextcloud/coding-standard' => array(
            'pretty_version' => 'v1.2.1',
            'version' => '1.2.1.0',
            'reference' => 'cf5f18d989ec62fb4cdc7fc92a36baf34b3d829e',
            'type' => 'library',
            'install_path' => __DIR__ . '/../nextcloud/coding-standard',
            'aliases' => array(),
            'dev_requirement' => true,
        ),
        'php-cs-fixer/shim' => array(
            'pretty_version' => 'v3.62.0',
            'version' => '3.62.0.0',
            'reference' => '7a91d5ce45c486f5b445d95901228507a02f60ae',
            'type' => 'application',
            'install_path' => __DIR__ . '/../php-cs-fixer/shim',
            'aliases' => array(),
            'dev_requirement' => true,
        ),
    ),
);
