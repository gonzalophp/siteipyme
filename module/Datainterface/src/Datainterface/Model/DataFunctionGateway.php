<?php
namespace Datainterface\Model;

class DataFunctionGateway implements \Zend\ServiceManager\FactoryInterface{
    
    public $serviceLocator;
    public $oAdapter;
    
    public function getDataRecordSet($sSchema, $sFunction, $aParameters=array()) {
        $sSql = 'SELECT * FROM '.(!empty($sSchema)?'"'.$sSchema.'".':'').$sFunction.'('.implode(',',array_keys($aParameters)).');';
        $oStatement = $this->oAdapter->query($sSql);
        $oResultSet = $oStatement->execute($aParameters);
        
        return $oResultSet;
    }
    
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        $this->oAdapter = $this->serviceLocator->get('Zend\Db\Adapter\Adapter');
        return $this;
    }
}    
?>
