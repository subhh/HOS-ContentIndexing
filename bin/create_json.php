<?php

 $id = basename($argv[1]);

 $text = json_encode(file_get_contents($argv[1]));

 $json = ' [ {"id" : "' . $id . '", "fulltext" : {"set":' . $text . '} } ] ';

 file_put_contents ( $argv[2], $json);

?>
