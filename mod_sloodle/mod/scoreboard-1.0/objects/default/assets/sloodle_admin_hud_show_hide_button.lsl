/*********************************************
*  sloodle_admin_hud_show_hide_button
*********************************************/

integer toggle;

default
{
    state_entry()
    {
        llSetTexture("hidehud", ALL_SIDES);
        toggle=-1;
    }
    
    
    touch_start(integer total_number)
    {
        if (toggle==-1){
            llMessageLinked(LINK_SET, 0, "hide", NULL_KEY);
            llSetTexture("showhud", ALL_SIDES);
            llSetObjectName("show");
        }
        else if (toggle==1){
            llMessageLinked(LINK_SET,0,"show",NULL_KEY);
            llSetTexture("hidehud", ALL_SIDES);
            llSetObjectName("hide");
        }
        toggle *= -1;
    }


    on_rez(integer num)
    {
        llResetScript();
    }

}

// Please leave the following line intact to show where the script lives in Git:
// SLOODLE LSL Script Git Location: mod/scoreboard-1.0/objects/default/assets/sloodle_admin_hud_show_hide_button.lsl

