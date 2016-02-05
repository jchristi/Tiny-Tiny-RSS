<?php
	require_once "functions.php";

	function ttrss_class_autoload($class) {
		$class_file = str_replace("_", "/", strtolower(basename($class)));

		$file = dirname(dirname(__FILE__))."/classes/$class_file.php";

		if (file_exists($file)) {
			require $file;
    }
  }

  spl_autoload_register('ttrss_class_autoload');
?>
