<?php
// Simulates an ajax object-rezzing request

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

require_once '../../../lib/json/json_encoding.inc.php';

$configVars = array();

$layoutentryid = null;
if (isset($_POST['layoutentryid'])) {
	$layoutentryid = intval($_POST['layoutentryid']);
}

//$rezzeruuid = optional_param( 'rezzeruuid', null, PARAM_SAFEDIR ); 

if (!$layoutentryid) {
	error_output( 'Layout entry ID missing');
}

$result = '';
$layoutentry = new SloodleLayoutEntry();

// Already gone - return that it's deleted.
if (!$layoutentry->load($layoutentryid)) {
	$result = 'deleted';
} 

if (!$result) {
    $layout = new SloodleLayout();
    if (!$layout->load($layoutentry->layout)) {
        error_output('Layout not found');
    }

    //$controller_context = get_context_instance( CONTEXT_MODULE, $layout->controllerid);
    $controller_context = context_module::instance($layout->controllerid);
    if (!has_capability('mod/sloodle:uselayouts', $controller_context)) {
            error_output( 'Access denied');
    }

    if (!$layoutentry->delete()) {
        error_output('Layout entry deletion failed');
    }

    $result = 'deleted';
}



/*
// FOR NOW: Leaving this for later
// If we have a rezzer, derez any outstanding objects
if ($rezzeruuid) {
	$active_objects = $controller->get_active_objects( $rezzeruuid, $layoutentryid );

	foreach($active_objects as $ao) {
		if (!$ao->deRez()) {
			$failures[] = $ao;
		}
	}
}
*/



$content = array(
	'result' => $result,
	'layoutentryid' => $layoutentryid,
	'layoutid' => $_REQUEST['layoutid']
);

$rand = rand(0,10);
//sleep($rand);
print json_encode($content);
exit;

function error_output($error) {
        $content = array(
                'result' => 'failed',
                'error' => $error,
        );
        print json_encode($content);
        exit;
}
?>
