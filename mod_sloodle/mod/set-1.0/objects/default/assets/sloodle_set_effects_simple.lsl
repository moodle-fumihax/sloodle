/*********************************************
*  sloodle_set_effects_simple
*********************************************/

integer SLOODLE_CHANNEL_OBJECT_CREATOR_REZZING_STARTED = -1639270082;
integer SLOODLE_CHANNEL_OBJECT_CREATOR_REZZING_FINISHED = -1639270083;
integer SLOODLE_CHANNEL_OBJECT_CREATOR_WILL_REZ_AT_POSITION = -1639270084;
integer SLOODLE_CHANNEL_SET_CONFIGURED = -1639270091;
integer SLOODLE_CHANNEL_SET_RESET = -1639270092;


default
{
    link_message(integer sender_num, integer num, string str, key id) 
    {
        if (num == SLOODLE_CHANNEL_OBJECT_CREATOR_REZZING_STARTED) {
            // TODO: Change color or something
            //llSetTimerEvent(5.0);         
        } 
        else if (num == SLOODLE_CHANNEL_OBJECT_CREATOR_REZZING_FINISHED) {
            //llParticleSystem([]);
        } 
        else if (num == SLOODLE_CHANNEL_SET_CONFIGURED) {
            //
        } 
        else if (num == SLOODLE_CHANNEL_SET_RESET) {
            //
        }
    }
    
    
    on_rez(integer num)
    {
        llResetScript();
    }
    
    
    state_entry()
    {
        llSetText("", <0,0,0>, 0.0);
    }
    

    changed(integer change) 
    {
        if (change & CHANGED_REGION_START) {
            llResetScript();
        }        
    }    
}

// Please leave the following line intact to show where the script lives in Git:
// SLOODLE LSL Script Git Location: mod/set-1.0/objects/default/assets/sloodle_set_effects_simple.lsl

