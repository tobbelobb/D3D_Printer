// Collected from ready made (bought) parts' blueprints or measured with calipers
// Note that these numbers are determined the moment external hardware orders are placed

// General
Steel_thickness   = 3;

// Nema17 motor
Nema17_cube_width          = 42.43;
Nema17_cube_height         = 39.36;
Nema17_shaft_height        = 63.65;
Nema17_ring_radius         = 11;
Nema17_ring_height         = 2;
Nema17_screw_hole_width    = 43.74; // Opposite corner screws
Nema17_screw_hole_dist     = Nema17_screw_hole_width/sqrt(2);
Nema17_screw_hole_diameter = 5.92;
Nema17_screw_hole_depth    = 2.25;
Nema17_motor_shaft         = 5;

// M3 screw
M3_diameter                = 3;
M3_radius                  = 1.5;
M3_head_diameter           = 6.3;
M3_wrench_size             = 5.5;
M3_head_height             = 2.5;

// 608 Bearing
Bearing_608_width          = 7;
Bearing_608_bore_diameter  = 8;
Bearing_608_outer_diameter = 22;
Bearing_608_bore_radius    = 4;
Bearing_608_outer_radius   = 11;

// 623 Bearing
Bearing_623_width          = 4;
Bearing_623_bore_diameter  = 3;
Bearing_623_outer_diameter = 10;
Bearing_623_bore_radius    = 1.5;
Bearing_623_outer_radius   = 5;

// Leadscrew
Nema17_with_leadscrew_height           = 300;
Leadscrew_number_of_starts             = 4;
Leadscrew_r                            = 4;
Leadscrew_lead_of_thread               = 8;
Leadscrew_flanged_nut_screw_hole_width = 16; // Opposite corner screws

// Flanged nut
Flanged_nut_height  = 15;
Flange_thickness    = 3.5;
Flange_offset       = 1.5;
Flanged_nut_small_r = 10.2/2;
Flanged_nut_big_r   = 22/2;

// Smooth rods
Smooth_rod_r      = 5; // 10 mm diameter
// NOTE:  The design of the linear actuator module imposes constraints on "smooth rod length"
//        that depend on "leadscrew lengths" or vice verca. Since smooth rods are cheaper
//        than leadscrews, we put smooth rod length in Design_numbers.scad
