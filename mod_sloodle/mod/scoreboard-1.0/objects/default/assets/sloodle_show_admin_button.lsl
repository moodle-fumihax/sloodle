//
// The line above should be left blank to avoid script errors in OpenSim.

/*
* showadminpanel.lsl
* Part of the Sloodle project (www.sloodle.org)
* 
*  Copyright (c) 2011-06 contributors (see below)
*  Released under the GNU GPL v3
* 
* Contributors:
*  Edmund Edgar
*  Paul Preibisch
*/

//string OPEN  = "p12";
//string CLOSE = "p13";

integer SLOODLE_CHANNEL_OBJECT_DIALOG = -3857343;
integer toggle = 1;
integer TIMER  = 1;

vector RED      = <1.00000, 0.00000, 0.00000>;
vector ORANGE   = <1.00000, 0.43763, 0.02414>;
vector YELLOW   = <1.00000, 1.00000, 0.00000>;
vector GREEN    = <0.00000, 1.00000, 0.00000>;
vector BLUE     = <0.00000, 0.00000, 1.00000>;
vector BABYBLUE = <0.00000, 1.00000, 1.00000>;
vector PINK     = <1.00000, 0.00000, 1.00000>;
vector PURPLE   = <0.57338, 0.25486, 1.00000>;
vector BLACK    = <0.00000, 0.00000, 0.00000>;
vector WHITE    = <1.00000, 1.00000, 1.00000>;


default
{
    on_rez(integer start_param) {
        llResetScript();
    }
    
    
    state_entry()
    {
        //llOwnerSay("Power Down");
        //llTriggerSound("powerdown", 1);
        //llMessageLinked(LINK_ALL_OTHERS, -99, OPEN, NULL_KEY); 
        llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.0 ] );
        llSetTimerEvent(0);
    }
    

    touch_start(integer total_number)
    {
        key toucher = llDetectedKey(0);
        if (toucher!=llGetOwner()) return;
        
        if (toggle==-1) { //OPEN
            //llOwnerSay("Power Down");
            llTriggerSound("SND_INTERFACE_BEEP", 1);
            llSetColor(YELLOW, ALL_SIDES);
            llSleep(0.5);
            llSetColor(WHITE, ALL_SIDES);
            //llMessageLinked(LINK_ALL_OTHERS, -99, CLOSE, NULL_KEY);
            
            llTriggerSound("powerdown", 1);
            llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.0 ] );
            llSetTimerEvent(0);
        }
        else { //close
            //llOwnerSay("Power Up");
            llTriggerSound("SND_INTERFACE_BEEP", 1);
            llSetColor(YELLOW, ALL_SIDES);
            llSleep(0.5);
            llSetColor(WHITE, ALL_SIDES);
            //llMessageLinked(LINK_ALL_OTHERS, -99, OPEN, NULL_KEY);
            llMessageLinked(LINK_ALL_OTHERS, SLOODLE_CHANNEL_OBJECT_DIALOG, "do:requestconfig", NULL_KEY);
            
            llTriggerSound("powerup", 1);
            llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.2 ] );
            llSetTimerEvent(TIMER);
        }
        toggle *= -1;
    }
    
    
    link_message(integer sender_num, integer num, string str, key id) 
    {
        //when a control button is pressed, that control button will automatically send a close request, so stop timer so we dont close twice
        /* unused
        if (str==CLOSE){
            llSetTimerEvent(0);
            llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.0 ] );
            llTriggerSound("powerdown", 1);
        }*/
    }
    
    
    timer()
    {
        toggle *= -1;
        llSetTimerEvent(0);
        //llMessageLinked(LINK_ALL_OTHERS, -99, CLOSE, NULL_KEY);
        llSetPrimitiveParams( [ PRIM_GLOW, ALL_SIDES, 0.0 ] );
        llTriggerSound("powerdown", 1);
    }
}

// Please leave the following line intact to show where the script lives in Git:
// SLOODLE LSL Script Git Location: mod/scoreboard-1.0/objects/default/assets/sloodle_show_admin_button.lsl

