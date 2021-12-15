<?php

if (count($argv) != 3) {
    die('incorrect number of arguments');
}

$data = array_map(fn($line): array => array_map(fn($char): int => $char + 0, str_split(trim($line))), file($argv[2]));

switch ($argv[1]) {
case "part01":
    include_once "part01.php";
    break;
case "part02":
    include_once "part02.php";
    break;
}
?>
<?php /* vim: set expandtab tabstop=4 smarttab shiftwidth=4: */ ?>
