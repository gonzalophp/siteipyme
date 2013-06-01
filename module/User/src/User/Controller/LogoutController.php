<?php
namespace User\Controller;

class LogoutController extends \Zend\Mvc\Controller\AbstractActionController {
    
    public function indexAction() {
        if(array_key_exists('PHPSESSID',$_COOKIE)) unset($_COOKIE['PHPSESSID']);
        session_start();
        return new \Zend\View\Model\JsonModel(array());
    }
}
