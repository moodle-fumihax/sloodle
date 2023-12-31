/*********************************************
*  sloodle_shared_media_screen
*********************************************/

/*
*  Part of the Sloodle project (www.sloodle.org)
*
*  Copyright (c) 2011-06 contributors (see below)
*  Released under the GNU GPL v3
*  -------------------------------------------
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*  All scripts must maintain this copyrite information, including the contributer information listed
*
*  Contributors:
*  Paul Preibisch
*
*  DESCRIPTION
* Contributors:
*  Edmund Edgar
*  Paul Preibisch
*/

string currentUrl;
integer SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_OWNER  = -1639270111; // set the main shared media panel to the specified URL, accessible to the owner
integer SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_GROUP  = -1639270112; // set the main shared media panel to the specified URL, accessible to the group
integer SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_ANYONE = -1639270114; // set the main shared media panel to the specified URL, accessible to anyone

integer SLOODLE_LOAD_CURRENT_URL= -1639271137; //send message to shared media to open url that it is currently displaying in a browser.
integer SLOODLE_CHANNEL_OBJECT_DIALOG = -3857343;


init_script()
{
    llClearPrimMedia(3);  
    currentUrl = "";  
}


default
{
    on_rez(integer start_param)
    {
        init_script();  
    }
    
    
    state_entry()
    {
        init_script();  
    }
    
    
    link_message( integer sender_num, integer num, string str, key id )
    {
        if (num == SLOODLE_CHANNEL_OBJECT_DIALOG) {
            if (str=="do:reconfigure"||str=="do:reset"){
                llClearPrimMedia(3);
            }
        }
        else if ((num==SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_OWNER) || 
                 (num==SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_GROUP) || 
                 (num==SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_ANYONE)) {
            //
            if (llGetSubString(str,0,6)=="http://" || llGetSubString(str,0,7)=="https://") llOwnerSay(str);
            llSetColor(<1.00000, 1.00000, 1.00000>,3);
            integer perms = PRIM_MEDIA_PERM_OWNER;
            if (num==SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_GROUP) {
                perms = PRIM_MEDIA_PERM_GROUP;
            }
            else if (num==SLOODLE_CHANNEL_SET_SET_SHARED_MEDIA_URL_ANYONE) {
                perms = PRIM_MEDIA_PERM_ANYONE;
            }
            //
            currentUrl = str;
            llClearPrimMedia(3);
            llSetPrimMediaParams( 3, [ PRIM_MEDIA_CURRENT_URL, str, PRIM_MEDIA_HOME_URL, str, PRIM_MEDIA_FIRST_CLICK_INTERACT, TRUE, 
                                       PRIM_MEDIA_AUTO_ZOOM, TRUE, PRIM_MEDIA_AUTO_PLAY, TRUE, PRIM_MEDIA_PERMS_INTERACT, perms, 
                                       PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE ]);
        }
    }
    
    
    changed(integer num) 
    {
        if (num & CHANGED_REGION_START) {
            llResetScript();
        }        
    }    
}


// Please leave the following line intact to show where the script lives in Git:
// SLOODLE LSL Script Git Location: mod/set-1.0/objects/default/assets/sloodle_shared_media_screen.lsl

