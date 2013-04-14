<?php
namespace Datainterface\Model;

class TableInterface implements \Zend\ServiceManager\FactoryInterface{
    public $serviceLocator;
    public $oTable;
    public $id_key;
    public $aRecordData;
    
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        return $this;
    }
    
    public function getTableInterface($sSchema, $sTable, $id_key=null, $aRecordData=null){
        $this->id_key = $id_key;
        $this->aRecordData = $aRecordData;
        $this->oTable = $this->serviceLocator->get('Datainterface\Model\DataTableGateway')->getTableGateway($sSchema,$sTable);
        return $this;
    }
    
    public function save(){
        if (array_key_exists($this->id_key, $this->aRecordData)){
            $aWhere = array($this->id_key => $this->aRecordData[$this->id_key]);
            unset($this->aRecordData[$this->id_key]);
            $aSet = array();
            foreach($this->aRecordData as $sField => $sValue) {
                $aSet[$sField] = $sValue;
            }
            $aResult = $this->oTable->update($aSet,$aWhere);
            
        }
        else {
            $aInsert = array($this->id_key => new \Zend\Db\Sql\Predicate\Expression("DEFAULT"));
            foreach($this->aRecordData as $sField => $sValue) {
                $aInsert[$sField] = $sValue;
            }
            $aResult = $this->oTable->insert($aInsert);
        }
        return $aResult['success'];
    }
    
    public function delete(){
        if (array_key_exists($this->id_key,$this->aRecordData)){
            $aWhere = array($this->id_key => $this->aRecordData[$this->id_key]);
            $aResult = $this->oTable->delete($aWhere);
            return $aResult['success'];
        }
        else {
            return false;
        }
    }
    
    public function fetchAll(){
        return $this->oTable->select();
    }
}
?>