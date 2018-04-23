/* ------------------------------------------------
 SurfaceConstellations Project 
 University College London

 CROSS-DEVICE BRACKETS FOR 3D PRINT

 Published as academic paper at ACM CHI 2018, Montreal.
 Please cite as: 
 Nicolai Marquardt, Frederik Brudy, Can Liu, Benedikt Bengler, 
 and Christian Holz (2018). SurfaceConstellations: A Modular 
 Hardware Platform for Ad-Hoc Reconfigurable Cross-Device 
 Workspaces. In Proceedings of ACM CHI 2018.
 

 MIT License

 Copyright (c) 2018 Nicolai Marquardt, Frederik Brudy, Can Liu, 
 Benedikt Bengler and Christian Holz

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.


 
 Revision history:
 01: basic brackets
 02: added angles, support extensions
 03: openings, mirroring
 04: optimizations, first 3D test prints
 05: thinner design, second 3D test prints
 06: cut-out design change
 07: Added variable X/Y thickness values
 08: Added capacitive link
 09: Simplified code, third 3D test prints
 10: First capacitive link test prints
 11: Capacitive link improvements
 12: Mirroring improvements
 13: Extra extension support
 14: Fixed bugs with mirroring
 15: Support extension corrections
 16: Negative shell corrections
 17: CHI version
 18: Wide extension support
 19: GitHub release and MIT licence
 
 ------------------------------------------------ */
 




// /////////////////////////////////////////////////
/* [General] */
// /////////////////////////////////////////////////

//Number of brackets (all offset in 90 degrees)
brackets=2;//[1:4]

//Mirror at the x-axis 
mirror_X=0;

//Mirror at the y-axis 
mirror_Y=0;



// /////////////////////////////////////////////////
/* [Border and layers] */
// /////////////////////////////////////////////////

//Thickness of the outer border
border_width_X=7;//[4:20]
border_width_Y=8;//[4:20]

//Tablet cover width
// iPad Air 2     = 11mm
// Surface Pro 2  = 18mm
cover_width       = 11;//[4:20]

//Thickness of the top and bottom layer
layer_thickness=2.0;//[2:10]

//Thickness of the device (e.g., Tablet)
// iPad Air 1     = 7.3mm
// iPad Air 2     = 6.4mm
// iPad 3         = 9.5mm
// iPhone7        = 7.13mm
// Surface Pro 2  = 13.7mm
device_thickness=7.3;//[3:30]



//Tilt angle (around x axis)
angle=55;//[0:90]


//Length of each bracket side
length_X=60;//[20:100]
length_Y=60;//[20:100]

// Full height of the core layers
full_height = layer_thickness * 2 + device_thickness;



// /////////////////////////////////////////////////
/* [Stability extension] */
// /////////////////////////////////////////////////

//Stand extension length (to hold weight)
extension=150;//[0:200]

// Extensions support of the angled brackets
extension_support=25;
extension_thickness=10;
extension_support_width= cover_width + border_width_X;
extension_width= cover_width + border_width_X;

// Height of the ridge opening (for buttons, speaker)
ridge_height=0;//[0:10]



// /////////////////////////////////////////////////
/* [Capacitive Link (CL)] */
// /////////////////////////////////////////////////

// Width of the capacitive touch area
cl_touch_width = 12;//[1:10]

// Width of the capacitive core
cl_core_width = 8;//[1:10]

// ID position for capacitive links
cl_id_1=0.9;
cl_id_2=0.6;
cl_id_3=0;
cl_id_4=0;





//
// Override Presets
// (use for setting preset values)
//

// 1. Surface 2 pro, open bracket, long extension, 55 degree angle
//border_width_X     =7;
//border_width_Y     =1;
//extension          =150;
//length_X           =60;
//length_Y           =50;
//angle              =55;
//cover_width        =18;
//layer_thickness    =2.0;
//device_thickness   =13.1;


// 2. iPad Air 2, extension bracket, 50 degree angle
//border_width_X     =7;
//border_width_Y     =8;
//extension          =120;
//length_X           =60;
//length_Y           =60;
//angle              =50;
//cover_width        =11;
//layer_thickness    =2.0;
//device_thickness   = 6.4;








// /////////////////////////////////////////////////
// MAIN CODE
// /////////////////////////////////////////////////


// Run main build function
build();



// the main build method
module build(){
    
  //difference(){
  //    difference(){
  //      build_brackets();
  //      //build_device_shell();
  //    };
  //    build_capacitive_link();
  //}
  
  //build_capacitive_link();
  //build_brackets();
    
    difference(){
       build_brackets();
       build_device_shell_complete();
    };
}



// Construct capacitive link module
module build_capacitive_link(){
    
    color("red")
      cl_link(cl_id_1);
    
    color("red")
        rotate([0 ,angle,0])
          mirror([1,0,0])
            cl_link(cl_id_2);
    
    color("red")
        rotate([0 ,angle,0])
          mirror([1,0,0])
            mirror([0,1,0])
              cl_link(cl_id_3);
    
    color("red")
        mirror([0,1,0])
          cl_link(cl_id_4);   
}



// Construct single capacitive link module
module cl_link(id){
    if(id!=0){
        y=(border_width_X + cover_width + cl_core_width) + 
          (length_Y - (border_width_X + cover_width + cl_core_width)) * id;
        
        cube_offset = 2;
        translate([0,0,(cube_offset)])
        cube([cl_core_width, cl_core_width * 2, full_height-cube_offset]);
        
        translate([0,0,(layer_thickness+device_thickness)])
          cube([cl_core_width, y, layer_thickness]);
        
        cylinder_center_Y = (border_width_Y + cover_width + cl_touch_width/2.0);
        cylinder_center_X = y - cl_touch_width/2.0;
        
        translate([0,(y - cl_touch_width),(layer_thickness+device_thickness)])
          cube([cylinder_center_Y, cl_touch_width, layer_thickness]); 
        
        add_thickness = 0.3;
        
        translate([cylinder_center_Y,cylinder_center_X,(layer_thickness+device_thickness-add_thickness)])
          cylinder(layer_thickness + add_thickness, cl_touch_width/2.0, cl_touch_width/2.0, false);
    }
}




// Build the 'negative' model of the surface device, to cut it out
// of the surface brackets
module build_device_shell(){
    
    rotate([0 ,angle,0])
        rotate(90)
            translate([-200, border_width_Y, layer_thickness])
            cube([1000, 1000, device_thickness]);
    
    rotate([0 ,angle,0])
        rotate(90)
            translate([-200, border_width_Y + cover_width, layer_thickness])
            cube([1000, 1000, 1000]);
    
    rotate([0 ,angle,0])
        rotate(90)
            translate([-200, border_width_Y, (layer_thickness * 2 + device_thickness)])
            cube([1000, 1000, 1000]);
}



// Construct the device volumes 
module build_device_shell_complete(){
     mirror ([mirror_X,mirror_Y,0]) {
        
        for (count =[0:brackets - 1]){
            if(count == 0){
                    build_device();
            }
            else if(count == 1) {    
                rotate([0 ,angle,0])
                  mirror([1,0,0])
                    build_device();
            }
            else if(count == 2) {    
                rotate([0 ,angle,0])
                  mirror([1,0,0])
                   mirror([0,1,0])
                    build_device();
            }
            else if(count== 3){
                mirror([0,1,0])
                    build_device();
            }          
        }
    }
        
 
}

// Construct a single device volume
module build_device(){
    //translate([border_width_Y + layer_thickness * (angle / 90.0), border_width_X , layer_thickness])
    //        cube([1000, 1000, device_thickness]);
    
    
    translate([border_width_Y , border_width_X , layer_thickness])
            cube([1000, 1000, device_thickness]);
}




// Build the complete, multi-element bracket
module build_brackets()
{ 
        
    mirror ([mirror_X,mirror_Y,0]) {
        
        for (count =[0:brackets - 1]){
            if(count == 0){
                    build_bracket();
            }
            else if(count == 1) {    
                rotate([0 ,angle,0])
                  mirror([1,0,0])
                    build_bracket();
            }
            else if(count == 2) {    
                rotate([0 ,angle,0])
                  mirror([1,0,0])
                   mirror([0,1,0])
                    build_bracket();
            }
            else if(count== 3){
                mirror([0,1,0])
                    build_bracket();
            }          
        }
          
        
        // build the extension for additional weight support
        build_extension();

        
        // Build front for angled third-quadrant tilt
        if(brackets== 3){
             mirror([0,1,0])      
                cube([10, length_Y, (device_thickness + 2*layer_thickness)]);
        }
    }
}




// Add weight support at the back of the bracket
module build_extension(){    
    if(extension > 0){
        translate([-extension, 0, 0])
            cube([extension,  extension_width, extension_thickness]);
        
        if(brackets >2){
            translate([-extension, -(extension_width), 0])
                cube([extension,  extension_width, extension_thickness]);
        }       
    }
    
    if(extension_support > 0){
        difference(){
            translate([-extension_support, 0, 0])
                cube([extension_support,  extension_support_width, 800]);
            build_device_shell();
        }
        
        if(brackets >2){
            difference(){
                translate([-extension_support, -(extension_support_width), 0])
                    cube([extension_support,  extension_support_width, 800]);
                 build_device_shell();
            }
        }       
    }  
}



// Build a single L-shape bracket
module build_bracket(){
    slide_bracket(border_width_X, length_X);
    mirror([1,-1,0])    
        slide_bracket(border_width_Y, length_Y);
}


// Build a single slide-in element for the tablet
module slide_bracket(bw, length){  
    difference(){
        difference() {
            cube([length, bw+cover_width, (device_thickness + 2*layer_thickness)]);
            translate([0, bw, layer_thickness])
                cube([length, cover_width, device_thickness]);
        };
        translate([4, 0, (((device_thickness + 2*layer_thickness) - ridge_height) / 2.0)])
        cube([length - 8, bw,  ridge_height]);
    }      
}

