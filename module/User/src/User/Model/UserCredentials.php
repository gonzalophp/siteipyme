<?php
namespace User\Model;

class UserCredentials implements \Zend\ServiceManager\FactoryInterface{
    public $serviceLocator;
    public $oUser;
    public $bInitialized = false;
    
    public function initialize() {
        if ($this->bInitialized) return;
        @session_start();
        $sSessionId = session_id();
        
        $oDataFunctionGateway = $this->serviceLocator->get('Datainterface\Model\DataFunctionGateway');
        $oResultSet = $oDataFunctionGateway->getDataRecordSet(
            'IPYME_FINAL'
            , 'get_user'
            , array(':p_u_session' => $sSessionId));
        
        $this->oUser = $oResultSet->current();
        $this->bInitialized = true;
    }
    
    public function isAuthenticated() {
        $this->initialize();
        return ($this->oUser!==FALSE);
    }
    
    public function getUserDetails() {
        $this->initialize();
        return $this->oUser;
    }

    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        return $this;
    }
}
?>