<?php
/** Grab the Sloodle/Moodle configuration. */
require_once('../../../init.php');
/** Include the Sloodle PHP API. */
/** Sloodle core library functionality */
require_once(SLOODLE_DIRROOT.'/lib.php');
/** General Sloodle functions. */
require_once(SLOODLE_LIBROOT.'/io.php');
/** Sloodle course data. */
require_once(SLOODLE_LIBROOT.'/course.php');
require_once(SLOODLE_LIBROOT.'/layout_profile.php');
require_once(SLOODLE_LIBROOT.'/active_object.php');

require_once(SLOODLE_LIBROOT.'/user.php');
require_once(SLOODLE_LIBROOT.'/object_configs.php');

require_once '../../../lib/json/json_encoding.inc.php';

$controllerid = optional_param('controllerid', 0, PARAM_INT);

// TODO: What should this be? Probably not 1...
//$controller_context = get_context_instance( CONTEXT_MODULE, $controllerid);
$controller_context = context_module::instance($controllerid);
$can_use_layouts = has_capability('mod/sloodle:uselayouts', $controller_context);
if (!$can_use_layouts) {
	//include('../../../login/shared_media/index.php');
	error_output( 'Permission denied');
}

$layoutid = optional_param('layoutid', 0, PARAM_INT);
if (!$layoutid) {
	error_output( 'Layout ID missing');
}

$layout = new SloodleLayout();
if (!$layout->load( $layoutid )) {
	error_output('Could not load layout');
}

if (!$courseid = $layout->course) {
	error_output('Could not get courseid from layout');
}

$controllerid = optional_param('controllerid', 0, PARAM_INT);

//$controller_context = get_context_instance( CONTEXT_MODULE, $controllerid);
$controller_context = context_module::instance($controllerid);
if (!has_capability('mod/sloodle:uselayouts', $controller_context)) {
        error_output( 'Access denied');
}


include('index.template.php');

$html_list_items = array();
$add_object_forms = array();
$edit_object_forms = array();

$rezzer = new SloodleActiveObject();
$sloodleuser = new SloodleUser();
$sloodleuser->user_data = $USER;

if (!$controllerid  = optional_param('controllerid', 0, PARAM_INT)) {
	error_output( 'Controller ID missing' );
}

if ( !$rezzeruuid = optional_param('rezzeruuid', '', PARAM_SAFEDIR) ) {
	error_output( 'Rezzer UUID missing or incorrect' );
}

if ( !$rezzer->loadByUUID($rezzeruuid) ) {
	error_output( 'Rezzer could not be loaded' );
}

$objects_in_rezzer = $rezzer->listInventory( $include_sloodle = false );
if ( $objects_in_rezzer === FALSE) {
	error_output('Fetching inventory failed');
}

//$objects_in_rezzer = array('Dummy Object 1', 'Dummy Object 2', 'Dummy Object 3');

foreach($objects_in_rezzer as $objname) {
	$e = SloodleLayoutEntry::ForConfig( $objname, $is_dummy = true); 
    // If we already know about the object, don't add it again.
    if (SloodleObjectConfig::ForObjectName($objname, false)) {
        continue;
    }
	$config = SloodleObjectConfig::ForNonSloodleObjectWithName( $objname ); 

	ob_start();
	//print_rezzable_item_li( $e, $courseid, $controllerid, $layout, $isrezzed = false); 
	$element_id = print_add_object_item_li( $objname, $config, $courseid, $controllerid, $layout); 

	$html_list_items[$element_id] = ob_get_clean();

	ob_start();
	$element_id = print_add_object_form( $config, $courseid, $controllerid, $layout, $objname, $rezzeruuid);
	$add_object_forms[$element_id] = ob_get_clean();

	ob_start();
	$element_id = print_config_form( $e, $config, $courseid, $controllerid, $layout->id, 'misc', $rezzeruuid);
	$edit_object_forms[$element_id] = ob_get_clean();

}

$content = array(
	'result' => 'refreshed',
	//'layoutname' => $layoutname, // TODO: Get this from the object_configs
	//'layoutid' => $layoutid,
	//'courseid' => $courseid,
	'html_list_items' => $html_list_items,
	'add_object_forms' => $add_object_forms,
	'edit_object_forms' => $edit_object_forms
);

print json_encode($content);
exit;
$result = 'configured';

$content = array(
	'result' => $result,
	'error' => $error,
);

function error_output($error) {
	$content = array(
		'result' => 'failed',
		'error' => $error,
	);
	print json_encode($content);
	exit;
}
?>
