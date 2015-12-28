// Here goes non parametric and ad hoc modules

// Help to think about shape and size of print bed...
module print_bed(){
  translate([-100,50,233]){
    cube([200,200,3]);
    color("purple") translate([100,100,2]) cylinder(r=30,h=50);
  }
}
