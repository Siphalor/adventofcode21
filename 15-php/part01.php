<?php

global $data;
$costs = array_fill(0, count($data), array_fill(0, count($data[0]), PHP_INT_MAX));

$costs[0][0] = 0;

$changed = true;
while ($changed) {
    $changed = false;
    foreach ($costs as $y => &$row) {
        foreach ($row as $x => &$ele) {
            $base = $data[$x][$y];
            if ($y > 0 && $costs[$y-1][$x] + $base < $ele) {
                $changed = true;
                $ele = $costs[$y-1][$x] + $base;
            }
            if ($y < count($costs) - 1 && $costs[$y+1][$x] + $base < $ele) {
                $changed = true;
                $ele = $costs[$y+1][$x] + $base;
            }
            if ($x > 0 && $costs[$y][$x-1] + $base < $ele) {
                $changed = true;
                $ele = $costs[$y][$x-1] + $base;
            }
            if ($x < count($row) - 1 && $costs[$y][$x+1] + $base < $ele) {
                $changed = true;
                $ele = $costs[$y][$x+1] + $base;
            }
        }
    }
}

$cost = $costs[count($costs)-1][count($costs[0])-1];
?>
The cost is <?php echo $cost; ?>.
<?php /* vim: set expandtab tabstop=4 smarttab shiftwidth=4: */ ?>
