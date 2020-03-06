#!/bin/bash

echo "<?php
\$global['configurationVersion'] = 2;
\$global['disableAdvancedConfigurations'] = 0;
\$global['videoStorageLimitMinutes'] = 0;
\$global['webSiteRootURL'] = 'https://'.'$WEB_URL'.'.video.poy.cn';
\$global['systemRootPath'] = '/var/www/html/';
\$global['salt'] = uniqid();
\$global['enableDDOSprotection'] = 1;
\$global['ddosMaxConnections'] = 40;
\$global['ddosSecondTimeout'] = 5;
\$global['strictDDOSprotection'] = 0;

\$mysqlHost = '$DATABASE_HOST';
\$mysqlPort = '$DATABASE_PORT';
\$mysqlUser = '$DATABASE_USER';
\$mysqlPass = '$DATABASE_PWD';
\$mysqlDatabase = '$DATABASE_NAME';

/**
 * Do NOT change from here
 */

require_once \$global['systemRootPath'].'objects/include_config.php';" > /var/www/html/videos/configuration.php

exec "$@"