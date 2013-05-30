<?php
namespace User\Model;

class UserCredentials implements \Zend\ServiceManager\FactoryInterface{
    public $serviceLocator;
    public $oUser;
    
    public function isAuthenticated() {
        @session_start();
        $sSessionId = session_id();
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
            'IPYME_FINAL'
            , 'get_user'
            , array(':p_u_session' => $sSessionId));
        
        $this->oUser = $oResultSet->current();
        return !is_null($this->oUser);
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