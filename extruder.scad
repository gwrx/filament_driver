
// Variables
bearing_outer_diameter = 16;
bearing_inner_diameter = 5;
bearing_height = 5;
bearing_clearing = 1;

drive_outer_diameter = 9;
drive_inner_diameter = 6;
drive_height = 11;
drive_driver_diameter = 7;
drive_driver_height = 3;
drive_driver_position = 6; // From the bottom to the bottom of driver

motor_diameter = 36;
motor_height = 22.7;
motor_shank_diameter = 22;
motor_shank_height = 2;
motor_shaft_diameter = drive_inner_diameter;
motor_shaft_height = 16;
motor_mounting_screw_diameter = 3;
motor_mounting_screw_length = motor_shaft_height + motor_shank_height;
motor_mounting_screw_distance = 20; // center to center

pneumatic_screw_diameter = 4;
pneumatic_screw_height = 4;

filament_diameter = 1.75;

module extruder_main() {
	difference() {
		//basic clearing
		translate([0,0,-motor_shank_height])
			cylinder(d=motor_diameter,h=motor_shaft_height+motor_shank_height);
		translate([0,0,1])
			cylinder(d2=drive_outer_diameter+1, d1=motor_shank_diameter+1, h=motor_shaft_height-drive_height+drive_driver_position-3, $fn=60);
		translate([0,0,0-motor_shank_height-0.05])
			cylinder(d=motor_shank_diameter+1, h=motor_shank_height+1.10, $fn=60);
		//driver
		translate([0,0,motor_shaft_height-drive_height+drive_driver_position-3])
			cylinder(d=drive_outer_diameter+1, h=drive_height, $fn=30);

		//filament
		rotate([90,0,0])
			translate([
					(drive_driver_diameter/2)+(filament_diameter/2),
					(motor_shaft_height - drive_height)+drive_driver_position+(drive_driver_height/2),
					-50])
				cylinder(d=filament_diameter+0.5, h= 100, $fn=15);
		//bearing clearing
		translate([
		bearing_outer_diameter/2+drive_outer_diameter/2, 0,0]) {
			cylinder(d=bearing_outer_diameter+1, h=motor_shaft_height+motor_shank_height);
		}
		//divider
		translate([drive_driver_diameter/2+filament_diameter/4+(bearing_outer_diameter-bearing_inner_diameter)/4,-motor_diameter/2-1,-motor_shank_height-1])
			cube([motor_height,motor_diameter+2,motor_height]);
		//screws
		rotate([0,0,45]) {
			translate([motor_mounting_screw_distance/2, motor_mounting_screw_distance/2, 0-motor_shank_height-1])
				cylinder(d=motor_mounting_screw_diameter+0.5, h=motor_mounting_screw_length+2, $fn=15);
			translate([0-motor_mounting_screw_distance/2, motor_mounting_screw_distance/2, 0-motor_shank_height-1])
				cylinder(d=motor_mounting_screw_diameter+0.5, h=motor_mounting_screw_length+2, $fn=15);
			translate([0-motor_mounting_screw_distance/2, 0-motor_mounting_screw_distance/2, 0-motor_shank_height-1])
				cylinder(d=motor_mounting_screw_diameter+0.5, h=motor_mounting_screw_length+2, $fn=15);
		}
		//tube-adapter
		// TODO add the tube adapters


	}
}

module bearing() {
	translate([
		bearing_outer_diameter/2+drive_outer_diameter/2, 0, motor_shaft_height-drive_height + drive_driver_position+(drive_driver_height/2)-bearing_height/2]) {
		difference() {
			cylinder(d=bearing_outer_diameter, h=bearing_height);
			translate([0,0,-1]) 
				cylinder(d=bearing_inner_diameter, h=bearing_height+2);
		}
	}
}

module drive() {
	translate([0,0,motor_shaft_height - drive_height]) {
		difference() {
			cylinder(d=drive_outer_diameter, h=drive_height, $fn=25);
			translate([0,0,-0.1])
				cylinder(d=drive_inner_diameter, h=drive_height + 2, $fn=25);
			difference() {
				translate([0,0,drive_driver_position]) 
					cylinder(d=drive_outer_diameter + 1, h=drive_driver_height, $fn=25);
				translate([0,0,drive_driver_position]) 
					cylinder(d=drive_driver_diameter, h=drive_driver_height, $fn=25);
			}
		}
	}
}

module filament() {
	color("red") {
	rotate([90,0,0]) 
		translate([
			(drive_driver_diameter/2)+(filament_diameter/2),
			(motor_shaft_height - drive_height)+drive_driver_position+(drive_driver_height/2),
			-50])
		cylinder(d=filament_diameter, h= 100, $fn=15);
	}
}

module motor_mounting_scew() {
		cylinder(d=motor_mounting_screw_diameter, h=motor_mounting_screw_length, $fn=15);
		translate([0,0,motor_mounting_screw_length])
			cylinder(d=motor_mounting_screw_diameter*1.5, h=motor_mounting_screw_diameter, $fn=15);
}

module motor() {
	color("silver", 1) {
		rotate([0,0,45]) {
			union() {
				difference() {
					union() {
						translate([0,0,0-motor_height - motor_shank_height]) {
							cylinder(d=motor_diameter, h=motor_height, $fn=60);
							translate([0,0,motor_height]) 
								cylinder(d=motor_shank_diameter, h=motor_shank_height, $fn=50);
							translate([0,0,motor_height + motor_shank_height]) 
								cylinder(d=motor_shaft_diameter, h=motor_shaft_height, $fn=30);
						}
					}
					translate([1.5,-5,2])
						cube([10,10,motor_shaft_height]);
				}
				translate([motor_mounting_screw_distance/2, motor_mounting_screw_distance/2, 0-motor_shank_height])
					motor_mounting_scew();
				translate([0-motor_mounting_screw_distance/2, motor_mounting_screw_distance/2, 0-motor_shank_height])
						motor_mounting_scew();
				translate([0-motor_mounting_screw_distance/2, 0-motor_mounting_screw_distance/2, 0-motor_shank_height])
						motor_mounting_scew();
			}
		}
	}
}

//motor();
filament();
bearing();
drive();
extruder_main();
