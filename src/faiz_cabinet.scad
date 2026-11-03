// Gridfinity 5x5 / 4-drawer cabinet
// Designed for fully 3D-printed, open-back construction.
// Revised: 2026-10-30
// - Fit a full 210 x 210 mm baseplate inside each drawer.
// - Remove duplicate side_groove()/drawer() definitions.
// - Keep the stacking features removed (as requested).
// 2026-11-03: Add removable FAIZ rear tie bars, one per drawer level.
// 2026-11-03: Add keyed, printed-only front stops for the bottom sliding joints.
// 2026-11-03: Add top-panel stops with extended noses, fitted from above.
// 2026-11-03: Add a transport lid, removable front gate/frame/clips, and underside stow snaps.

// Transport kit: print 1 lid, 1 front gate, 1 frame and 4 identical lock clips.
// Fit the gate behind the handle, seat the lid with its snap pegs UP, place the
// frame, then clip all four locks into the original side grooves. For removal,
// ease each clip's lower dog outward before lifting the frame and lid.
// Cabinet mode: remove gate/frame/clips and snap the bare lid to the underside.
// Stored hook tips project about 0.5 mm above the inside floor: test your bins.
// PETG spring geometry is a trial design; use lid_snap_coupon to tune the fit.
// Confirm holding force and distortion on physical parts before loaded transport.

part = "assembly"; // [assembly,left,right,top,bottom,drawer,drawer_plate,tie_bar,rail_coupon,plate_coupon,honey_coupon,panel_joint_coupon,rail_stop_left,rail_stop_right,rail_stops,top_rail_stop_left,top_rail_stop_right,top_rail_stops,drawer_lid,lid_front_gate,lid_transport_frame,lid_lock_clip,drawer_transport,drawer_lid_stored,lid_snap_coupon]
$fn = 64;
exploded = 0;
show_all_drawers = true;

drawer_count = 4;
levels = max(1, floor(drawer_count));
preview_pulled_drawer = -1;
pulled_drawer_index = preview_pulled_drawer < 0 ? levels - 1
    : min(levels - 1, max(0, floor(preview_pulled_drawer)));

grid_pitch = 42;
grid_x = 5;
grid_y = 5;
grid_w = grid_pitch * grid_x;
grid_d = grid_pitch * grid_y;
baseplate_w = grid_w;
baseplate_d = grid_d;
baseplate_h = 5;          // Visual reference plate thickness
plate_clearance = 0.45; // Clearance between plate and drawer walls PER SIDE

wall_t = 4;
back_t = 3.2;
panel_t = 8;
panel_honey_r = 7;
panel_honey_web = 1.6;
panel_honey_margin = 13;
panel_side_overhang = 5;

// Rails and fitting
rail_r = 3.2;
rail_front_gap = 6;
rail_back_gap = 5;
rail_z = 7;
rail_clearance = 0.45;
groove_r = rail_r + rail_clearance;
groove_skin = 1.2;
rail_entry = 8;
drawer_clearance = 0.45;

// Drawer and front
// The groove is tangent to the drawer's outer face. Its deepest cut leaves
// groove_skin between the groove and the drawer's interior.
drawer_side_t = groove_r + groove_skin;
drawer_h = 38;
drawer_gap = 2;
bottom_clearance = 3;
level_pitch = drawer_h + drawer_gap;
tray_bottom_t = 2.4;
drawer_back_t = 3.2;
front_lip_t = 3.2;
front_lip_h = 8;
plate_pocket_depth = 1.2;
honey_cell_r = 7;
honey_web = 1.6;
honey_margin = 8;
handle_outer_w = 86;
handle_outer_h = 25;
handle_band = 5.6;
handle_depth = 6.4;
handle_forward = 10;
handle_bottom_z = front_lip_h - 0.8;
handle_gusset = 10;

// IMPORTANT: size the drawer's usable cavity around the FULL baseplate,
// not just the drawer's external dimensions.
// Old design: 212.0 x 212.45 outer tray, leaving only 202.3 x 206.05 inside.
tray_w = baseplate_w + 2 * (drawer_side_t + plate_clearance);
tray_d = baseplate_d + front_lip_t + drawer_back_t + 2 * plate_clearance;
inner_w = tray_w + 2 * drawer_clearance;
inner_d = tray_d + drawer_clearance + 1;
outer_w = inner_w + 2 * wall_t;
outer_d = inner_d + back_t;
panel_w = outer_w + 2 * panel_side_overhang;
side_h = bottom_clearance + levels * level_pitch;
outer_h = 2 * panel_t + side_h;

// Side frame and dovetail-style joints
snap_root_w = wall_t;
snap_head_w = 6.4;
snap_depth = 4;
snap_clearance = 0.30;
snap_inner_overhang = (snap_head_w - snap_root_w) / 2;
truss_end_post = 8;
truss_chord = 6.4;
truss_rail_chord = 8;
truss_diag = 4;

// Removable rear tie bars (mm). The beam and jaws take their thickness from wall_t.
tie_bar_h = 8;              // Vertical height of the beam and claws
tie_bar_clearance = 0.30;   // Per post face, independent of the panel joint fit
tie_bar_stop_gap = 0.30;    // From the closed drawer back to the unloaded beam

// Front joint stops. The existing 3.2 mm blind groove backs stop rearward travel.
rail_stop_plate_t = 2;          // Bottom: below drawer; top: above top panel
rail_stop_t = 4;                // Front abutment depth
rail_stop_gap = 0.25;           // Side-wall travel before hitting the front stop
rail_stop_key_depth = 7;        // Honeycomb key engagement below the panel top
rail_stop_key_clearance = 0.20; // Per hex face on the rigid shear key
rail_stop_spring_interference = 0.10; // Per face, adjust after a trial print

// Transport kit. Remove gate, frame and all four lock clips before cabinet use.
// The lid alone stores on the drawer underside. No internal baseplate is used.
lid_preview = "stored"; // [none,stored]
lid_t = 0.8;             // 0.2 mm clearance above the bottom rail-stop saddles
lid_fit = 0.25;
lid_spring_length = 16;
lid_spring_w = 1.2;
lid_spring_slot = 0.6;
lid_hook_overlap = 0.30;
lid_hook_clearance = 0.10;
lid_frame_t = 4;
lid_frame_web = 2.4;
lid_clip_w = 8;
lid_clip_leg_t = 2.4;
lid_clip_bite = 2;



assert(drawer_count >= 1, "drawer_count must be >= 1");
assert(drawer_h > 0, "drawer_h must be positive");
assert(drawer_gap >= 0, "drawer_gap cannot be negative");
assert(plate_pocket_depth < tray_bottom_t, "Plate pocket would cut through tray bottom");
assert(tray_w - 2 * drawer_side_t >= baseplate_w + 2 * plate_clearance - 0.001,
    "Insufficient drawer interior width for baseplate");
assert(tray_d - front_lip_t - drawer_back_t >= baseplate_d + 2 * plate_clearance - 0.001,
    "Insufficient drawer interior depth for baseplate");

module hex2d(r) {
    polygon([for (a = [0:60:300]) [r * cos(a), r * sin(a)]]);
}

module clipped_trap_2d(up = true) {
    if (up)
        polygon([[0,0], [wall_t,0], [wall_t + snap_inner_overhang,snap_depth], [0,snap_depth]]);
    else
        polygon([[0,0], [wall_t,0], [wall_t + snap_inner_overhang,-snap_depth], [0,-snap_depth]]);
}

// Display-only placeholder, not an actual Gridfinity locking plate.
module baseplate_placeholder() {
    color("SeaGreen", 0.55)
    difference() {
        cube([baseplate_w, baseplate_d, baseplate_h]);
        for (x = [1:grid_x-1])
            translate([x*grid_pitch-0.3, 0, baseplate_h-0.5])
                cube([0.6, baseplate_d, 0.6]);
        for (y = [1:grid_y-1])
            translate([0, y*grid_pitch-0.3, baseplate_h-0.5])
                cube([baseplate_w, 0.6, 0.6]);
    }
}

module round_rail(length) {
    rotate([-90,0,0])
    linear_extrude(length)
    intersection() {
        circle(r = rail_r);
        translate([0,-rail_r-0.1]) square([rail_r+0.1, 2*rail_r+0.2]);
    }
}

module arch_handle() {
    rotate([90,0,0])
    linear_extrude(handle_depth)
    difference() {
        intersection() {
            scale([handle_outer_w/2,handle_outer_h]) circle(r=1);
            translate([-handle_outer_w/2,0]) square([handle_outer_w,handle_outer_h+0.1]);
        }
        intersection() {
            scale([(handle_outer_w-2*handle_band)/2, handle_outer_h-handle_band]) circle(r=1);
            translate([-(handle_outer_w-2*handle_band)/2,-0.1])
                square([handle_outer_w-2*handle_band,handle_outer_h+0.2]);
        }
    }
}

module clipped_rail_y(length, up = true) {
    rotate([90,0,0]) linear_extrude(length) clipped_trap_2d(up);
}

module side_clipped_trap_rails(left = true) {
    if (left) {
        translate([0,inner_d,0]) clipped_rail_y(inner_d,false);
        translate([0,inner_d,side_h]) clipped_rail_y(inner_d,true);
    } else {
        translate([wall_t,inner_d,0]) mirror([1,0,0]) clipped_rail_y(inner_d,false);
        translate([wall_t,inner_d,side_h]) mirror([1,0,0]) clipped_rail_y(inner_d,true);
    }
}

module yz_bar(y1,z1,y2,z2,w = truss_diag) {
    hull() {
        translate([wall_t/2,y1,z1]) cube([wall_t,w,w],center=true);
        translate([wall_t/2,y2,z2]) cube([wall_t,w,w],center=true);
    }
}

module side_truss_frame() {
    union() {
        cube([wall_t,truss_end_post,side_h]);
        translate([0,inner_d-truss_end_post,0]) cube([wall_t,truss_end_post,side_h]);
        cube([wall_t,inner_d,truss_chord]);
        translate([0,0,side_h-truss_chord]) cube([wall_t,inner_d,truss_chord]);
        for (i = [0:levels-1]) {
            zc = bottom_clearance + i*level_pitch + rail_z;
            translate([0,0,zc-truss_rail_chord/2])
                cube([wall_t,inner_d,truss_rail_chord]);
        }
        z_nodes = concat([truss_chord/2],
            [for (i=[0:levels-1]) bottom_clearance+i*level_pitch+rail_z],
            [side_h-truss_chord/2]);
        for (i = [0:len(z_nodes)-2]) {
            yz_bar(truss_end_post,z_nodes[i],inner_d-truss_end_post,z_nodes[i+1]);
            yz_bar(inner_d-truss_end_post,z_nodes[i],truss_end_post,z_nodes[i+1]);
        }
    }
}

module side_panel(left = true) {
    union() {
        side_truss_frame();
        side_clipped_trap_rails(left);
        for (i = [0:levels-1]) {
            zc = bottom_clearance + i*level_pitch + rail_z;
            if (left)
                translate([wall_t,rail_front_gap,zc])
                    round_rail(inner_d-rail_front_gap-rail_back_gap);
            else
                translate([0,rail_front_gap,zc]) mirror([1,0,0])
                    round_rail(inner_d-rail_front_gap-rail_back_gap);
        }
    }
}

module panel_honeycomb_holes() {
    xmin = wall_t + panel_honey_margin;
    xmax = outer_w - wall_t - panel_honey_margin;
    ymin = panel_honey_margin;
    ymax = inner_d - panel_honey_margin;
    sx = 1.5 * (panel_honey_r + panel_honey_web/2);
    sy = sqrt(3) * (panel_honey_r + panel_honey_web/2);
    for (ix=[-1:ceil((xmax-xmin)/sx)+1])
        for (iy=[-1:ceil((ymax-ymin)/sy)+1]) {
            x = xmin+ix*sx;
            y = ymin+iy*sy+(ix%2)*sy/2;
            if (x>xmin && x<xmax && y>ymin && y<ymax)
                translate([x,y,-0.1])
                    linear_extrude(panel_t+0.2) hex2d(panel_honey_r);
        }
}

module panel_clipped_trap_grooves(is_top = false) {
    left_outer_x = panel_side_overhang;
    right_outer_x = panel_side_overhang+outer_w;
    z0 = is_top ? 0 : panel_t;
    translate([left_outer_x,inner_d,z0])
        rotate([90,0,0]) linear_extrude(inner_d+0.2)
            offset(delta=snap_clearance) clipped_trap_2d(is_top);
    translate([right_outer_x,inner_d,z0]) mirror([1,0,0])
        rotate([90,0,0]) linear_extrude(inner_d+0.2)
            offset(delta=snap_clearance) clipped_trap_2d(is_top);
}

module top_panel() {
    difference() {
        cube([panel_w,outer_d,panel_t]);
        translate([panel_side_overhang,0,0]) panel_honeycomb_holes();
        panel_clipped_trap_grooves(true);
    }
}

module bottom_panel() {
    difference() {
        cube([panel_w,outer_d,panel_t]);
        translate([panel_side_overhang,0,0]) panel_honeycomb_holes();
        panel_clipped_trap_grooves(false);
    }
}

module honeycomb_holes() {
    xmin = drawer_side_t+honey_margin;
    xmax = tray_w-drawer_side_t-honey_margin;
    ymin = front_lip_t+honey_margin;
    ymax = tray_d-drawer_back_t-honey_margin;
    sx = 1.5*(honey_cell_r+honey_web/2);
    sy = sqrt(3)*(honey_cell_r+honey_web/2);
    for (ix=[-1:ceil((xmax-xmin)/sx)+1])
        for (iy=[-1:ceil((ymax-ymin)/sy)+1]) {
            x = xmin+ix*sx;
            y = ymin+iy*sy+(ix%2)*sy/2;
            if (x>xmin && x<xmax && y>ymin && y<ymax)
                translate([x,y,-0.1])
                    linear_extrude(tray_bottom_t+0.2) hex2d(honey_cell_r);
        }
}

module side_groove(left = true) {
    xc = left ? -groove_r+(drawer_side_t-groove_skin)
              : tray_w+groove_r-(drawer_side_t-groove_skin);
    translate([xc,rail_entry,rail_z]) rotate([-90,0,0])
        cylinder(h=tray_d-rail_entry+1,r=groove_r);
    translate([xc,-0.1,rail_z]) rotate([-90,0,0])
        cylinder(h=rail_entry+0.2,r=groove_r+0.6);
}

module drawer(include_plate = false) {
    difference() {
        // Group the shell before subtracting the many honeycomb holes (F5 preview).
        render(convexity=8) union() {
            cube([tray_w,tray_d,tray_bottom_t]);
            translate([0,0,tray_bottom_t])
                cube([drawer_side_t,tray_d,drawer_h-tray_bottom_t]);
            translate([tray_w-drawer_side_t,0,tray_bottom_t])
                cube([drawer_side_t,tray_d,drawer_h-tray_bottom_t]);
            translate([0,tray_d-drawer_back_t,tray_bottom_t])
                cube([tray_w,drawer_back_t,drawer_h-tray_bottom_t]);
            translate([0,0,tray_bottom_t])
                cube([tray_w,front_lip_t,front_lip_h]);
            translate([tray_w/2,-handle_forward+handle_depth,handle_bottom_z])
                arch_handle();
            hull() {
                translate([0,0,0])
                    cube([drawer_side_t,front_lip_t,handle_bottom_z+handle_gusset]);
                translate([(tray_w-handle_outer_w)/2,-handle_forward,0])
                    cube([handle_band,handle_depth,handle_bottom_z+handle_gusset]);
            }
            hull() {
                translate([tray_w-drawer_side_t,0,0])
                    cube([drawer_side_t,front_lip_t,handle_bottom_z+handle_gusset]);
                translate([(tray_w+handle_outer_w)/2-handle_band,-handle_forward,0])
                    cube([handle_band,handle_depth,handle_bottom_z+handle_gusset]);
            }
        }
        side_groove(true);
        side_groove(false);
        honeycomb_holes();
        translate([(tray_w-baseplate_w)/2,(tray_d-baseplate_d)/2,
                   tray_bottom_t-plate_pocket_depth])
            cube([baseplate_w,baseplate_d,plate_pocket_depth+0.15]);
    }
    if (include_plate)
        translate([(tray_w-baseplate_w)/2,(tray_d-baseplate_d)/2,
                   tray_bottom_t-plate_pocket_depth])
            baseplate_placeholder();
}

// Small pieces for fitting and flow/speed tests before a full cabinet print.
module rail_coupon() {
    translate([0,0,0]) {
        cube([wall_t,70,20]);
        translate([wall_t,5,rail_z]) round_rail(60);
    }
    translate([20,0,0])
    difference() {
        cube([drawer_side_t,70,20]);
        translate([groove_r+groove_skin,rail_entry,rail_z])
            rotate([-90,0,0]) cylinder(h=61,r=groove_r);
        translate([groove_r+groove_skin,-0.1,rail_z])
            rotate([-90,0,0]) cylinder(h=rail_entry+0.2,r=groove_r+0.6);
    }
}

module plate_coupon() {
    difference() {
        cube([55,55,4]);
        translate([4,4,2.8])
            cube([42+2*plate_clearance,42+2*plate_clearance,1.3]);
    }
}

module honey_coupon() {
    difference() {
        cube([80,80,tray_bottom_t]);
        for (ix=[0:7]) for (iy=[0:7]) {
            x=7+ix*1.5*(honey_cell_r+honey_web/2);
            y=7+iy*sqrt(3)*(honey_cell_r+honey_web/2)
                +(ix%2)*sqrt(3)*(honey_cell_r+honey_web/2)/2;
            translate([x,y,-0.1])
                linear_extrude(tray_bottom_t+0.2) hex2d(honey_cell_r);
        }
    }
}

module panel_joint_coupon() {
    color("SlateGray")
    union() {
        translate([0,0,snap_depth]) cube([wall_t,60,24]);
        translate([0,60,snap_depth]) rotate([90,0,0])
            linear_extrude(60) clipped_trap_2d(false);
    }
    color("DimGray") translate([20,0,0])
    difference() {
        cube([wall_t+snap_inner_overhang+8,60,panel_t]);
        translate([0,60,panel_t]) rotate([90,0,0])
            linear_extrude(60.2) offset(delta=snap_clearance)
                clipped_trap_2d(false);
    }
}

// Local Y=0 is the rear face of the side posts; Z=0 is the flat print face.
// Both U mouths face the cabinet centre. With drawers and panels removed,
// shift each wall inward by toe_tip_x + c (3.30 mm by default). Slide the bars
// forward from the rear, then seat the walls outward into the two U pockets.
module tie_bar() {
    t = wall_t;
    c = tie_bar_clearance;
    outer_x = -c - t;
    toe_y = -truss_end_post - c - t;
    toe_tip_x = 0.75 * t;             // Bearing width across the front of the post
    // Leave a straight path between the toe tip and beam step for the full post.
    shoulder_x = toe_tip_x + t + 2*c;
    stop_y = tray_d + tie_bar_stop_gap - inner_d;

    assert(c >= 0 && tie_bar_stop_gap >= 0, "Tie-bar clearances must be nonnegative");
    assert(tie_bar_h > 0 && rail_z + truss_rail_chord/2 + tie_bar_h <= drawer_h,
        "Tie bar must fit above the rail chord and within the drawer back height");
    assert(2 * (shoulder_x + t) < outer_w, "Insufficient space for tie-bar shoulders");

    module left_claw_2d() {
        // Outside cheek arrests wall splay. The front toe bears the drawer thrust.
        translate([outer_x, toe_y]) square([t, c + t - toe_y]);
        translate([outer_x, toe_y]) square([toe_tip_x - outer_x, t]);
        // Rear jaw and shoulder join the offset stop beam inside the post.
        translate([outer_x, c]) square([shoulder_x + t - outer_x, t]);
        translate([shoulder_x, min(c, stop_y)]) square([t, t + abs(c - stop_y)]);
    }

    linear_extrude(height=tie_bar_h)
        union() {
            left_claw_2d();
            translate([outer_w, 0]) mirror([1, 0, 0]) left_claw_2d();
            translate([shoulder_x, stop_y]) square([outer_w - 2*shoulder_x, t]);
        }
}

module installed_tie_bars() {
    for (i = [0:levels-1]) {
        // The two front toes sit on the existing horizontal truss chords.
        chord_top = bottom_clearance + i*level_pitch + rail_z + truss_rail_chord/2;
        translate([0, inner_d, panel_t + exploded + chord_top]) tie_bar();
    }
}

// Follow the existing staggered honeycomb: left/right anchor rows differ.
function rail_stop_anchors(left = true) =
    let(xmin = wall_t + panel_honey_margin,
        xmax = outer_w - wall_t - panel_honey_margin,
        sx = 1.5 * (panel_honey_r + panel_honey_web/2),
        sy = sqrt(3) * (panel_honey_r + panel_honey_web/2),
        ix = left ? 1 : ceil((xmax-xmin)/sx)-1,
        x = xmin + ix*sx,
        y = panel_honey_margin + (ix%2 == 0 ? sy : sy/2))
    [[left ? x : outer_w-x, y], [left ? x : outer_w-x, y+sy]];

// Local X points inward from the wall's outside face. Z matches the chosen panel.
// The near peg takes shear, the far peg adds compliant, removable lift retention.
// Remove the lowest drawer, push the walls fully back, then press each stop down
// into its two honeycomb holes. Top stops press into the top panel from above,
// leaving the drawer path clear and a 2 mm pad above the top surface.
// Lift the saddle to remove. Print a trial first
// and tune rail_stop_spring_interference for your material and printer.
// Top stops sit above the top panel. Their longer nose reaches the underside groove.
module rail_stop(left = true, top = false) {
    anchors = rail_stop_anchors(left);
    pad_r = panel_honey_r + 1.5;
    neck_x = wall_t + snap_clearance + 0.2;
    neck_w = 6;
    front_y = -rail_stop_gap - rail_stop_t;
    peg_z = panel_t - rail_stop_key_depth;
    nose_depth = top ? panel_t : snap_depth;
    a = panel_honey_r*cos(30);
    tongue_w = 4;
    tongue_t = 1.6;
    tongue_relief = 1.2;
    core_half_y = a - rail_stop_key_clearance - tongue_t - tongue_relief;

    assert(rail_stop_plate_t > 0 && (top || rail_stop_plate_t < bottom_clearance),
        "Rail stop must fit under the lowest drawer");
    assert(rail_stop_key_depth > 2 && rail_stop_key_depth < panel_t,
        "Rail-stop keys must stay within the panel thickness");
    assert(rail_stop_key_clearance >= 0 && core_half_y > 0,
        "Invalid hex-key clearance");
    assert(rail_stop_spring_interference >= 0 && rail_stop_spring_interference <= 0.3,
        "Use 0..0.3 mm spring interference per face");
    assert(anchors[1][1]+pad_r < inner_d-panel_honey_margin,
        "Panel is too short for two rail-stop anchors");

    // Hex key with a short lead-in. Stop thrust bears on the hex flats.
    module shear_key() {
        hull() {
            translate([0,0,peg_z])
                linear_extrude(0.1)
                    offset(delta=-rail_stop_key_clearance-0.6) hex2d(panel_honey_r);
            translate([0,0,peg_z+1.2])
                linear_extrude(rail_stop_key_depth-1.1)
                    offset(delta=-rail_stop_key_clearance) hex2d(panel_honey_r);
        }
    }

    module retaining_key() {
        // Keep a rigid X locator, leaving free space behind the two spring tongues.
        intersection() {
            shear_key();
            translate([-panel_honey_r,-core_half_y,peg_z-0.1])
                cube([2*panel_honey_r,2*core_half_y,rail_stop_key_depth+0.3]);
        }
        for (s = [-1,1]) scale([1,s,1])
            hull() {
                // Narrow pilot, then a shallow crown for push-in / pull-out use.
                translate([-tongue_w/2,a-rail_stop_key_clearance-tongue_t,peg_z])
                    cube([tongue_w,tongue_t-0.5,0.1]);
                translate([-tongue_w/2,a+rail_stop_spring_interference-tongue_t,peg_z+1.2])
                    cube([tongue_w,tongue_t,0.2]);
                translate([-tongue_w/2,a-rail_stop_key_clearance-tongue_t,panel_t-0.8])
                    cube([tongue_w,tongue_t,0.9]);
            }
    }

    union() {
        // Seat directly on the panel. The neck stays inside the side wall.
        translate([0,0,panel_t]) linear_extrude(rail_stop_plate_t)
            union() {
                hull() {
                    translate([neck_x,front_y]) square([neck_w,rail_stop_t]);
                    translate(anchors[0]) circle(r=pad_r);
                }
                hull() for (p = anchors) translate(p) circle(r=pad_r);
            }
        // Close the front joint opening while remaining outside the panel edge.
        translate([-snap_clearance,front_y,panel_t-nose_depth])
            cube([neck_x+neck_w+snap_clearance,rail_stop_t,
                  nose_depth+rail_stop_plate_t]);
        translate([anchors[0][0],anchors[0][1],0]) shear_key();
        translate([anchors[1][0],anchors[1][1],0]) retaining_key();
    }
}

module installed_rail_stops(top = false) {
    panel_z = top ? panel_t + side_h + 2*exploded : 0;
    translate([0,0,panel_z]) {
        rail_stop(true,top);
        translate([outer_w,0,0]) mirror([1,0,0]) rail_stop(false,top);
    }
}

// Flat top on the bed: pegs and front nose print upward without supports.
module rail_stop_print(left = true, top = false) {
    translate([0,0,panel_t+rail_stop_plate_t]) rotate([180,0,0])
        scale([left ? 1 : -1,1,1]) rail_stop(left,top);
}

// Four actual drawer-floor holes, two per side. Front/rear hooks face outward.
function lid_snap_anchors() =
    let(sx = 1.5*(honey_cell_r+honey_web/2),
        sy = sqrt(3)*(honey_cell_r+honey_web/2),
        xmin = drawer_side_t+honey_margin,
        xmax = tray_w-drawer_side_t-honey_margin,
        ymin = front_lip_t+honey_margin,
        ymax = tray_d-drawer_back_t-honey_margin,
        last_ix = ceil((xmax-xmin)/sx)-1)
    [for (ix = [3,last_ix-3])
        let(x = xmin+ix*sx,
            last_iy = ceil((ymax-ymin)/sy-(ix%2)/2)-1)
        for (rear = [false,true])
            [x,ymin+(rear ? last_iy : 1)*sy+(ix%2)*sy/2,rear ? 1 : -1]];

function lid_clip_stations() = [18,tray_d-26];
function lid_frame_z() = drawer_h+lid_t+0.10;
function lid_clip_top_z() = lid_frame_z()+lid_frame_t+0.15;
function lid_hook_height() = tray_bottom_t-plate_pocket_depth+lid_hook_clearance+0.40;
function lid_pocket_x() = -lid_spring_length-lid_spring_slot-0.6;
function lid_pocket_w() = lid_spring_length+lid_spring_slot+honey_cell_r+1.2;
function lid_pocket_h() = 2*(honey_cell_r+1.2);

module lid_checks() {
    assert(lid_t > 0 && lid_t < bottom_clearance-rail_stop_plate_t,
        "Stored lid must clear the lower rail-stop saddles");
    assert(lid_t < drawer_gap, "Stored lid must clear the drawer below");
    assert(lid_spring_length > 10 && lid_spring_w > 0 && lid_spring_slot > 0,
        "Invalid lid spring dimensions");
    assert(lid_hook_overlap > 0 && lid_hook_overlap <= 0.5,
        "Use 0..0.5 mm lid hook overlap");
    assert(lid_frame_t > lid_hook_height()+0.4, "Frame roof must clear the snap heads");
    assert(lid_clip_bite > 0 && lid_clip_bite < groove_r, "Invalid transport clip bite");
    assert(lid_clip_stations()[1] > lid_clip_stations()[0]+lid_clip_w+10,
        "Drawer is too short for the lock clips");
    for (p = lid_snap_anchors())
        assert(p[0]+lid_pocket_x() > 0 && p[0]+honey_cell_r < tray_w
            && p[1]-honey_cell_r > front_lip_t
            && p[1]+honey_cell_r < tray_d-drawer_back_t,
            "Drawer is too small for the lid snap positions");
}

// In-plane cantilever slot. Its root is at X=-lid_spring_length.
module lid_spring_relief_2d() {
    a = honey_cell_r*cos(30);
    arm_y = a-lid_fit-lid_spring_w/2;
    arm_end = 1.6;
    translate([-lid_spring_length,arm_y-lid_spring_w/2-lid_spring_slot])
        square([lid_spring_length+arm_end+lid_spring_slot,lid_spring_slot]);
    translate([-lid_spring_length,arm_y+lid_spring_w/2])
        square([lid_spring_length+arm_end+lid_spring_slot,lid_spring_slot]);
    translate([arm_end,arm_y-lid_spring_w/2-lid_spring_slot])
        square([lid_spring_slot,lid_spring_w+2*lid_spring_slot]);
}

module lid_snap() {
    a = honey_cell_r*cos(30);
    floor_h = tray_bottom_t-plate_pocket_depth;
    stem_inner = a-lid_fit-lid_spring_w;
    shoulder_z = lid_t+floor_h+lid_hook_clearance;
    // A short partial hex ring centres the lid without crossing the floor top.
    translate([0,0,lid_t]) linear_extrude(min(0.85,floor_h-0.2))
        difference() {
            offset(delta=-lid_fit) hex2d(honey_cell_r);
            offset(delta=-lid_fit-0.9) hex2d(honey_cell_r);
            translate([-lid_spring_length-1,a-lid_fit-lid_spring_w-lid_spring_slot])
                square([lid_spring_length+honey_cell_r+2,
                        lid_spring_w+2*lid_spring_slot+1]);
        }
    // Profile coordinates are Y,Z; extrusion runs across X.
    rotate([90,0,90]) linear_extrude(3.2,center=true)
        polygon([[stem_inner,lid_t-0.05],
                 [a-lid_fit,lid_t-0.05],
                 [a-lid_fit,lid_t+floor_h],
                 [a+lid_hook_overlap,shoulder_z],
                 [a+lid_hook_overlap,shoulder_z+0.05],
                 [a-lid_fit,shoulder_z+0.40],
                 [stem_inner,shoulder_z+0.40]]);
}

// Printed as shown: flat sheet on the bed, all pegs upward.
module drawer_lid() {
    lid_checks();
    difference() {
        union() {
            translate([0,-3.6,0]) cube([tray_w,tray_d+3.6,lid_t]);
            translate([tray_w/2-12,-6,0]) cube([24,3,lid_t]);
        }
        for (p = lid_snap_anchors())
            translate([p[0],p[1],-0.1]) scale([1,p[2],1])
                linear_extrude(lid_t+0.2) lid_spring_relief_2d();
    }
    for (p = lid_snap_anchors())
        translate([p[0],p[1],0]) scale([1,p[2],1]) lid_snap();
}

module stored_drawer_lid() {
    translate([0,0,-lid_t]) drawer_lid();
}

module lid_frame_outline_2d() {
    rim = 5.6;
    union() {
        difference() {
            translate([0,-3.6]) square([tray_w,tray_d+3.6]);
            translate([rim,rim]) square([tray_w-2*rim,tray_d-2*rim]);
        }
        for (i = [1:grid_x-1])
            translate([(tray_w-baseplate_w)/2+i*grid_pitch-lid_frame_web/2,0])
                square([lid_frame_web,tray_d]);
        for (i = [1:grid_y-1])
            translate([0,(tray_d-baseplate_d)/2+i*grid_pitch-lid_frame_web/2])
                square([tray_w,lid_frame_web]);
        // Solid roofs above all spring slots and snap heads.
        for (p = lid_snap_anchors())
            translate([p[0]+lid_pocket_x(),p[1]-lid_pocket_h()/2])
                square([lid_pocket_w(),lid_pocket_h()]);
        for (y = lid_clip_stations()) {
            translate([0,y-1]) square([13,lid_clip_w+2]);
            translate([tray_w-13,y-1]) square([13,lid_clip_w+2]);
        }
    }
}

// Local Z=0 is the face against the thin lid.
module lid_frame() {
    lid_checks();
    difference() {
        union() {
            linear_extrude(lid_frame_t) lid_frame_outline_2d();
            // Downward returns positively index the complete cap to the drawer.
            // Upper bridges join the returns above the thin lid.
            for (x = [40,tray_w-50]) {
                translate([x,-3.6-lid_fit-2,0]) cube([10,4,lid_frame_t]);
                translate([x,-3.6-lid_fit-2,drawer_h-2-lid_frame_z()])
                    cube([10,2,lid_frame_z()-(drawer_h-2)+0.1]);
                translate([x,tray_d-1,0]) cube([10,3.25,lid_frame_t]);
                translate([x,tray_d+lid_fit,drawer_h-2-lid_frame_z()])
                    cube([10,2,lid_frame_z()-(drawer_h-2)+0.1]);
            }
        }
        for (p = lid_snap_anchors())
            translate([p[0],p[1],-0.1]) scale([1,p[2],1])
                linear_extrude(lid_hook_height()+0.30)
                    union() {
                        // Follow the locating ring, with extra clearance for the hook.
                        offset(delta=0.40) hex2d(honey_cell_r);
                        translate([lid_pocket_x(),
                            honey_cell_r*cos(30)-lid_fit-lid_spring_w-lid_spring_slot-0.3])
                            square([lid_pocket_w(),lid_spring_w+2*lid_spring_slot+0.6]);
                    }
        for (y = lid_clip_stations())
            for (x = [8,tray_w-8])
                translate([x-1.2-lid_fit,y-lid_fit,-0.1])
                    cube([2.4+2*lid_fit,lid_clip_w+2*lid_fit,lid_frame_t+0.2]);
    }
}

module lid_frame_print() {
    translate([0,0,lid_frame_t]) rotate([180,0,0]) lid_frame();
}

// One common clip, printed on its broad side, four copies required.
module lid_lock_clip() {
    toe_z = rail_z+sqrt(groove_r*groove_r-lid_clip_bite*lid_clip_bite)-lid_fit;
    outside_x = -lid_fit-lid_clip_leg_t;
    top_z = lid_clip_top_z();
    linear_extrude(lid_clip_w) union() {
        translate([outside_x,toe_z-2])
            square([lid_clip_leg_t,top_z+2.4-(toe_z-2)]);
        translate([outside_x,top_z]) square([11-outside_x,2.4]);
        polygon([[outside_x,toe_z-2],[-lid_fit,toe_z-2],
                 [lid_clip_bite,toe_z-0.8],[lid_clip_bite,toe_z],
                 [outside_x,toe_z]]);
        // Full-width indexing finger drops into the frame's through-slot.
        translate([8-1.2,top_z-3.2]) square([2.4,3.3]);
    }
}

module installed_lid_clips() {
    for (y = lid_clip_stations()) {
        translate([0,y+lid_clip_w,0]) rotate([90,0,0]) lid_lock_clip();
        translate([tray_w,y,0]) rotate([90,0,180]) lid_lock_clip();
    }
}

// Front gate slides into the existing gap behind the arch handle.
module lid_front_gate() {
    gate_y = -handle_forward+handle_depth+lid_fit;
    gate_t = -lid_fit-gate_y;
    gate_x = drawer_side_t+lid_fit;
    gate_w = tray_w-2*gate_x;
    lip_top = tray_bottom_t+front_lip_h;
    union() {
        difference() {
            union() {
                translate([gate_x,gate_y,lip_top-0.6])
                    cube([gate_w,gate_t,drawer_h-(lip_top-0.6)]);
                translate([tray_w/2-32,gate_y,tray_bottom_t+2.4])
                    cube([64,gate_t,lip_top-(tray_bottom_t+2.4)]);
            }
            // Clearance around both original handle gussets.
            for (right = [false,true])
                translate([right ? tray_w : 0,0,0]) scale([right ? -1 : 1,1,1])
                    hull() {
                        translate([-lid_fit,-lid_fit,-lid_fit])
                            cube([drawer_side_t+2*lid_fit,front_lip_t+2*lid_fit,
                                  handle_bottom_z+handle_gusset+2*lid_fit]);
                        translate([(tray_w-handle_outer_w)/2-lid_fit,-handle_forward-lid_fit,-lid_fit])
                            cube([handle_band+2*lid_fit,handle_depth+2*lid_fit,
                                  handle_bottom_z+handle_gusset+2*lid_fit]);
                    }
        }
        for (x = [tray_w/2-24,tray_w/2+24])
            translate([x-4,-1,lip_top]) cube([8,front_lip_t-1.25+1,1.6]);
        // The locked lid captures this flange from above.
        translate([gate_x,gate_y,drawer_h-1.6])
            cube([gate_w,front_lip_t-lid_fit-gate_y,1.6]);
    }
}

module lid_front_gate_print() {
    translate([0,0,handle_forward-handle_depth-lid_fit])
        rotate([90,0,0]) lid_front_gate();
}

module lid_transport_kit() {
    color("Khaki") translate([0,0,drawer_h]) drawer_lid();
    color("DarkSlateGray") translate([0,0,lid_frame_z()]) lid_frame();
    color("Coral") lid_front_gate();
    color("SandyBrown") installed_lid_clips();
}

module drawer_transport() {
    color("LightSteelBlue") drawer(false);
    lid_transport_kit();
}

module lid_snap_coupon() {
    p = lid_snap_anchors()[0];
    translate([-p[0]+lid_spring_length+2,-p[1]+9,0])
        intersection() {
            drawer_lid();
            translate([p[0]-lid_spring_length-2,p[1]-9,-0.1])
                cube([lid_spring_length+honey_cell_r+4,18,10]);
        }
}

module assembly() {
    color("DimGray") translate([-panel_side_overhang,0,0])
        bottom_panel();
    color("SlateGray") translate([0,0,panel_t+exploded])
        side_panel(true);
    color("SlateGray") translate([outer_w-wall_t,0,panel_t+exploded])
        side_panel(false);
    color("DimGray")
        translate([-panel_side_overhang,0,panel_t+side_h+2*exploded])
            top_panel();

    color("SandyBrown") installed_tie_bars();
    color("IndianRed") installed_rail_stops();
    color("IndianRed") installed_rail_stops(true);

    for (i=[0:levels-1]) if (show_all_drawers || i==0) {
        pull = i==pulled_drawer_index ? 32 : 0;
        color(i==pulled_drawer_index ? "Orange" : "LightSteelBlue")
            translate([wall_t+drawer_clearance,-pull-i*exploded*0.25,
                       panel_t+bottom_clearance+i*level_pitch])
                drawer(false);
        if (i==pulled_drawer_index)
            translate([wall_t+drawer_clearance,-pull-i*exploded*0.25,
                       panel_t+bottom_clearance+i*level_pitch]) {
                if (lid_preview=="stored") color("Khaki") stored_drawer_lid();
            }
    }

    // Display-only top reference plate. No cabinet-stacking locks are present.
    translate([(outer_w-baseplate_w)/2,1.25,
               panel_t+side_h+panel_t+2.4+2*exploded])
        baseplate_placeholder();
}

if (part=="assembly") assembly();
else if (part=="left") side_panel(true);
else if (part=="right") side_panel(false);
else if (part=="top") top_panel();
else if (part=="bottom") bottom_panel();
else if (part=="drawer") drawer(false);
else if (part=="drawer_plate") drawer(true);
else if (part=="rail_coupon") rail_coupon();
else if (part=="plate_coupon") plate_coupon();
else if (part=="honey_coupon") honey_coupon();
else if (part=="panel_joint_coupon") panel_joint_coupon();
else if (part=="tie_bar") tie_bar();
else if (part=="rail_stop_left") rail_stop_print(true);
else if (part=="rail_stop_right") rail_stop_print(false);
else if (part=="rail_stops") {
    rail_stop_print(true);
    pair_spacing = rail_stop_anchors(true)[0][0] + rail_stop_anchors(false)[0][0]
        + 2*(panel_honey_r+1.5) + 10;
    translate([pair_spacing,0,0]) rail_stop_print(false);
}
else if (part=="top_rail_stop_left") rail_stop_print(true,true);
else if (part=="top_rail_stop_right") rail_stop_print(false,true);
else if (part=="top_rail_stops") {
    rail_stop_print(true,true);
    pair_spacing = rail_stop_anchors(true)[0][0] + rail_stop_anchors(false)[0][0]
        + 2*(panel_honey_r+1.5) + 10;
    translate([pair_spacing,0,0]) rail_stop_print(false,true);
}
else if (part=="drawer_lid") drawer_lid();
else if (part=="lid_front_gate") lid_front_gate_print();
else if (part=="lid_transport_frame") lid_frame_print();
else if (part=="lid_lock_clip") lid_lock_clip();
else if (part=="drawer_transport") drawer_transport();
else if (part=="drawer_lid_stored") {
    drawer(false);
    color("Khaki") stored_drawer_lid();
}
else if (part=="lid_snap_coupon") lid_snap_coupon();
else echo("Unknown part selector",part);

echo("Drawers",levels,"pitch",level_pitch);
echo("Grid size",grid_w,grid_d);
echo("Cabinet",outer_w,outer_d,outer_h,"panel width",panel_w);
echo("Snap fitting",snap_root_w,snap_head_w,snap_depth,"clearance",snap_clearance);
echo("Drawer outside",tray_w,tray_d,drawer_h);
echo("Drawer inside",tray_w-2*drawer_side_t,
     tray_d-front_lip_t-drawer_back_t,"plate",baseplate_w,baseplate_d);
echo("Truss",truss_end_post,truss_chord,truss_rail_chord,truss_diag);
