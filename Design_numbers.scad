// ********** Design numbers we're going to use when manufacturing by ourselves  ********** //
// ********** Derive these numbers to keep total design information content down ********** //
// General
Plastic_thickness = M3_wrench_size;                  // For plastic sheets/walls. Use sensibly
// Linear actuator module
Smooth_rod_length = Nema17_with_leadscrew_height + Plastic_thickness;
Clamp_height          = Nema17_cube_height/2 - 2;   // Must be < Nema17_cube_height/2
L_module_length       = Nema17_with_leadscrew_height + Plastic_thickness;
L_module_width        = 2*(L_module_length/2 - 3*Nema17_screw_hole_dist); // For flush top edge
Smooth_rod_separation = Nema17_cube_width+2*(Smooth_rod_r+3.5);
L_plate_height        = Nema17_cube_height + Plastic_thickness;
Linear_bearing_width  = Smooth_rod_r*2 + Bearing_623_outer_radius + 2*Plastic_thickness + M3_radius;
// Steel Frame
Side_length       = L_module_length;                 // Lengths of sides of individual sheets
Cube_X_length     = Side_length;                     // Outer measures of steel cube
Cube_Y_length     = Side_length + 2*Steel_thickness; // determined by corner mounting strategy
Cube_Z_length     = Side_length;
Frame_width       = max(2*Plastic_thickness + Nema17_cube_height, // See module mounting strategy
                        Nema17_cube_width + Steel_thickness);     // Flush l_modules and frame

// ********** Echoed derived design numbers below here ********** //
echo("Steel sheet frame weight (kg):");
Frame_weight = (4*Frame_width*(Side_length - Frame_width) * Steel_thickness * 4)*0.000008;
echo(Frame_weight);
