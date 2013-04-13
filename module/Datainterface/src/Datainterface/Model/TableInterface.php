<?php
namespace Datainterface\Model;

class TableInterface implements \Zend\ServiceManager\FactoryInterface{
    public $serviceLocator;
    
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        return $this;
    }
    
    public function save($sServiceTable, $id_key, $aRecordData){
        if (array_key_exists($id_key, $aRecordData)){
            $aWhere = array($id_key => $aRecordData[$id_key]);
            unset($aRecordData[$id_key]);
            $aSet = array();
            foreach($aRecordData as $sField => $sValue) {
                $aSet[$sField] = $sValue;
            }
            $oTable = $this->serviceLocator->get($sServiceTable);        
            $aResult = $oTable->update($aSet,$aWhere);
            
        }
        else {
            $aInsert = array($id_key => new \Zend\Db\Sql\Predicate\Expression("DEFAULT"));
            foreach($aRecordData as $sField => $sValue) {
                $aInsert[$sField] = $sValue;
            }
            $oTable = $this->serviceLocator->get($sServiceTable);        
            $aResult = $oTable->insert($aInsert);
        }
        return $aResult['success'];
    }
    
    public function delete($sServiceTable, $id_key, $aRecordData){
        if (array_key_exists($id_key,$aRecordData)){
            $aWhere = array($id_key => $aRecordData[$id_key]);
            $oTable = $this->serviceLocator->get($sServiceTable);        
            $aResult = $oTable->delete($aWhere);
            return $aResult['success'];
        }
        else {
            return false;
        }
    }
    
    public function fetchAll($sServiceTable){
        $oTable = $this->serviceLocator->get($sServiceTable);
        return $oTable->select();
    }
}
?>