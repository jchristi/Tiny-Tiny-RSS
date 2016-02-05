<?php

$root_dir = dirname(dirname(__FILE__));
set_include_path(
  "${root_dir}/tests/config" . PATH_SEPARATOR .
  "${root_dir}/include" . PATH_SEPARATOR .
  get_include_path()
);

chdir(dirname(dirname(__FILE__)));

require_once 'autoload.php';
require_once 'functions.php';
require_once 'rssfuncs.php';
require_once 'config.php';
require_once 'db.php';
require_once 'db-prefs.php';
