<?php
// This script is part of the Sloodle project
// Created for Avatar Classroom, with the intention of eventually being ported back to regular Sloodle.
// Some assumptions that are true for Avatar Classroom won't be true for arbitrary Moodle sites.
// I'll try to comment these REGULAR SLOODLE TODO.

/**
* @package sloodle
* @copyright Copyright (c) 2011 various contributors (see below)
* @license http://www.gnu.org/licenses/gpl-3.0.html GNU GPL v3
*
* @contributor Edmund Edgar
*
*/

/** Grab the Sloodle/Moodle configuration. */
require_once('../../../init.php');
/** Include the Sloodle PHP API. */
/** Sloodle core library functionality */
require_once(SLOODLE_DIRROOT.'/lib.php');
require_once(SLOODLE_DIRROOT.'/lib/db.php');

/** General Sloodle functions. */
require_once(SLOODLE_LIBROOT.'/general.php');
/** Sloodle course data. */
require_once(SLOODLE_LIBROOT.'/course.php');
require_once(SLOODLE_LIBROOT.'/io.php');

require_once(SLOODLE_LIBROOT.'/object_configs.php');
require_once(SLOODLE_LIBROOT.'/active_object.php');

require_once '../../../lib/json/json_encoding.inc.php';

require_once('scoreboard_active_object.inc.php');


$error = '';

$object_uuid = required_param('sloodleobjuuid', PARAM_RAW);
$sao = SloodleScoreboardActiveObject::ForUUID( $object_uuid );

$is_logged_in = isset($USER) && ($USER->id > 0);
$is_admin = $is_logged_in && has_capability('moodle/course:manageactivities', $sao->context);

if (!$is_admin) {
    header('HTTP/1.0 401 Unauthorized');
    exit;
}

$userids = required_param('userids', PARAM_RAW);
$userscores = required_param('userscores', PARAM_RAW);

$i=0;
foreach($userids as $userid) {
    //
    if (!$userid = intval($userid)) {
        continue;
    }
    $userscore = intval($userscores[$i]);
    $sao->modify_score($userid, $userscore);
    $i++;
}

$updated_scores = $sao->get_student_scores(true);
$result = 'updated';

$content = array(
    'result' => $result,
    'error'  => $error,
    'updated_scores' => $updated_scores
);

print json_encode($content);
exit;


//
function error_output($error)
{
    $content = array(
        'result' => 'failed',
        'error'  => $error,
    );
    print json_encode($content);
    exit;
}
