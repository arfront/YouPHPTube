#!/bin/bash

echo "<?php
\$global['configurationVersion'] = 2;
\$global['disableAdvancedConfigurations'] = 0;
\$global['videoStorageLimitMinutes'] = 0;
if(!empty(\$_SERVER['SERVER_NAME']) && \$_SERVER['SERVER_NAME']!=='localhost' && !filter_var(\$_SERVER['SERVER_NAME'], FILTER_VALIDATE_IP)) {
    // get the subdirectory, if exists
    \$subDir = str_replace(array(\$_SERVER[\"DOCUMENT_ROOT\"], 'videos/configuration.php'), array('',''), __FILE__);
    \$global['webSiteRootURL'] = \"http\".(!empty(\$_SERVER['HTTPS'])?\"s\":\"\").\"://\".\$_SERVER['SERVER_NAME'].\$subDir;
}else{
    \$global['webSiteRootURL'] = '$WEB_URL';
}
\$global['systemRootPath'] = '/var/www/html/';
\$global['salt'] = uniqid();
\$global['enableDDOSprotection'] = 1;
\$global['ddosMaxConnections'] = 40;
\$global['ddosSecondTimeout'] = 5;
\$global['strictDDOSprotection'] = 0;

\$mysqlHost = '$DATABASE_HOST';
\$mysqlPort = '$DATABASE_PORT';
\$mysqlUser = '$DATABASE_USERE';
\$mysqlPass = '$DATABASE_PWD';
\$mysqlDatabase = '$DATABASE_NAME';

/**
 * Do NOT change from here
 */

require_once \$global['systemRootPath'].'objects/include_config.php';" > /var/www/html/videos/configuration.php

exec "$@"