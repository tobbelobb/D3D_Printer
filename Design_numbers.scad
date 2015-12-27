
Steel_thickness   = 3;
Smooth_rod_r      = 5; // 10 mm diameter
Smooth_rod_length = 300;
Plastic_thickness = 2.5;
Clamp_height      = 15;

// Outermost lengths of frame cube
Cube_X_length     = Smooth_rod_length; // X in printer's coordinate sys
Cube_Y_length     = Smooth_rod_length + 2*Steel_thickness; // Y in printer's coordinate sys
Cube_Z_length     = 300;
Cross_width       = (Nema17_cube_width+Steel_thickness)*sqrt(2);

//L_module_width    = Nema17_cube_width+4*(Smooth_rod_r+4);
L_module_width    = Nema17_cube_width + 4*(Smooth_rod_r+6);
L_module_smooth_rod_separation = Nema17_cube_width+2*(Smooth_rod_r+3);

L_plate_height = Nema17_cube_height + Plastic_thickness;
