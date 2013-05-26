<?php
namespace User\Model;

class UserCredentials implements \Zend\ServiceManager\FactoryInterface{
    public $serviceLocator;
    public $oUser;
    
    public function isAuthenticated() {
        @session_start();
        $oUserTable = $this->serviceLocator->get('Datainterface\Model\DataTableGateway')->getTableGateway('IPYME_FINAL','USER');
        $aResult = $oUserTable->select(array('u_session'=>session_id()
                                            ,'u_status' => 1));
        $bAuthenticated = ($aResult['resultset']->count()==1) && $aResult['success'] && ($aResult['error_code']==0);
        $this->oUser = $bAuthenticated ? $aResult['resultset']->current() : NULL;
        return $bAuthenticated;
    }
    
    public function getUserDetails() {
        return $this->oUser;
    }

    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        return $this;
    }
}
?>