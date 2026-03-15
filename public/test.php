<?php
    // 输出九九乘法表
    for ($i=1; $i < 10; $i++) { 
        for ($j=1; $j <= $i; $j++) {
            $res = $i * $j; 
            echo "$j * $i = $res";
            // echo ' ';
            // echo '\t';
            // echo '\09';
            echo "\t\t";
        }
        echo '<p>';
    }