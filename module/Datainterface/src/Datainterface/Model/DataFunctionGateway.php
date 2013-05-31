<?php
namespace Datainterface\Model;

class DataFunctionGateway implements \Zend\ServiceManager\FactoryInterface{
    
    public $serviceLocator;
    public $oAdapter;
    
    public function getDataRecordSet($sSchema, $sFunction, $aParameters=array()) {
        return $this->oAdapter->query(
                str_replace(array('{SCHEMA}','{FUNCTION}','{PARAMETERS}')
                            ,array($sSchema, $sFunction, implode(',',array_keys($aParameters)))
                            ,'SELECT * FROM "{SCHEMA}".{FUNCTION}({PARAMETERS});'))->execute($aParameters);
    }
    
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        $this->oAdapter = $this->serviceLocator->get('Zend\Db\Adapter\Adapter');
        return $this;
    }
}    
?>
