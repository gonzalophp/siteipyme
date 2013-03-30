<?php
namespace Admin\Model;

class User {
	public $aLoginData;

	function __construct() {
		$this->aLoginData = (object) array('success'=>1);
	}
}