$fn = 365;
// tollerance
$tol = 0.05;
// How many chambers are there in the lock to hold pins?
$number_chambers = 5;
// distance from 0 to the start of the first pin
$first_pin_offset = 6.34;
// distace between each pin chamber in the plug/bible
$chamber_dist = 3.81;
// the diameter of the chambers
$chamber_dia = 3.31;

$plug_diamater = 12.8;
$plug_rim_dia = $plug_diamater + 3.5;
$plug_length = 34;

$bible_thickness = 2;
$keyway_length =  28;
$keyway_height = 11.3;
$keyway_width = 3;
$keyway_offset_from_top_plug_rim = 5.5;

module compare_to_kw1_plug(){
    difference() {
        // additive
        union() {
            cylinder(d1=$plug_diamater, d2=$plug_diamater, h=$plug_length);
            cylinder(d1=$plug_rim_dia, d2=$plug_rim_dia, h=2.5);
        }
        
        //substractive
        union() {
            // chamber holes
            for ( i = [0 : ($number_chambers - 1)] ){
                translate([0,.80,($first_pin_offset + ($chamber_dist*i))]) {
                    rotate([90, 0 , 0]){
                        cylinder(d1=$chamber_dia, d2=$chamber_dia, h=30);
                    }
                }
            }
            // front concave
            translate([0,1.6,-11]){
                sphere(d=25);
            }
            
            //keyway
            // the .39 is a correction after printing and testing lock
            rotate([180,0,0]){
                translate([-$keyway_width/2, ( ($keyway_height * -1) + ($plug_rim_dia /2) +.39) - $keyway_offset_from_top_plug_rim, -$keyway_length]){
                        linear_extrude(height =$keyway_length) import("keyway.svg");
                }
            }
        }
    }
}

module compare_to_kw1_bible(){
    difference() {
        //additive
        union(){
            translate([0,-6,0]){
                cylinder(d1= 36.4, d2=36.4, h=3.4);
            }
            translate([0,0,3.3]){
                cylinder(d1=$plug_diamater+$tol+4.09, d2=$plug_diamater+$tol+4.09, $plug_length-8.3);
            }
            translate([0,-11,3.3]){
                cylinder(d1=$plug_diamater+$tol+4.09, d2=$plug_diamater+$tol+4.09, $plug_length-8.3);
            }
        }
        //subtractive
        union() {
            translate([9,-7.75,-2]){
            rotate([0, 0, 180]) {
            linear_extrude(height =2.5) resize([0,10,0], auto=true) import("WheatForWoodMark.svg");
            }
        }
            // chamber holes
            for ( i = [0 : ($number_chambers-1)] ){
                translate([0,.80,($first_pin_offset + ($chamber_dist*i))]) {
                    rotate([90, 0 , 0]){
                        cylinder(d1=$chamber_dia, d2=$chamber_dia, h=18.8);
                    }
                }
            }
            
            // vent holes for chambers (to prevent top pins getting stuck issue due to vacuum)
            for ( i = [0 : ($number_chambers - 1)] ){
                translate([0,.80,($first_pin_offset + ($chamber_dist*i))]) {
                    rotate([90, 0 , 0]){
                        cylinder(d1=1, d2=1, h=25);
                    }
                }
            }
            
            // access to chamber holes for excess resin cleaning (to prevent excess resin getting stuck in chambers then curing issue)
            for ( i = [0 : ($number_chambers - 1)] ){
                translate([0,10,($first_pin_offset + ($chamber_dist*i))]) {
                    rotate([90, 0 , 0]){
                        cylinder(d1=$chamber_dia, d2=$chamber_dia, h=$bible_thickness*2);
                    }
                }
            }
            // inset for plug
            translate([0,0,-0.05]){
                // The 0.15 below is a manual ajdument after a LOT of trial/error
                cylinder(d1=$plug_diamater+$tol+0.15, d2=$plug_diamater+$tol+0.15, h=$plug_length);
                cylinder(d1=$plug_diamater+4.6+$tol, d2=$plug_diamater+4.6+$tol, h=2.6+$tol);
            }
            
        }
    }
}


compare_to_kw1_plug();
translate([50, 0, 0]){
compare_to_kw1_bible();
}
