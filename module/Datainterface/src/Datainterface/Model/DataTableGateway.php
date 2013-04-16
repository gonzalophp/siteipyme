<?php
namespace Datainterface\Model;

class DataTableGateway extends \Zend\Db\TableGateway\AbstractTableGateway implements \Zend\ServiceManager\FactoryInterface{
    const QUERY_SELECT=1;
    const QUERY_INSERT=2;
    const QUERY_UPDATE=3;
    const QUERY_DELETE=4;
    
    public $serviceLocator;
    
    public function getTableGateway($sSchema, $sTable) {
        $this->isInitialized = false;
        $this->sql = null;
        $this->table = new \Zend\Db\Sql\TableIdentifier($sTable,$sSchema);
        $this->adapter = $this->serviceLocator->get('Zend\Db\Adapter\Adapter');
        $row = $this->serviceLocator->get('Datainterface\Model\\'.ucfirst(strtolower($sTable)));
        $this->resultSetPrototype = new \Zend\Db\ResultSet\ResultSet(); 
        $this->resultSetPrototype->setArrayObjectPrototype($row);
        return $this;
    }
    
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator=$serviceLocator;
        return $this;
    }
    
    public function _query($nQuery, $aSet, $aWhere){
        try {
            switch($nQuery){
                case self::QUERY_SELECT:
                    $aResultSet = parent::select($aWhere);
                break;
                case self::QUERY_INSERT:
                    $aResultSet = parent::insert($aSet);
                break;
                case self::QUERY_UPDATE:
                    $aResultSet = parent::update($aSet, $aWhere);
                break;
                case self::QUERY_DELETE:
                    $aResultSet = parent::delete($aWhere);
                break;
            }
            $bSuccess = true;
            $nErrorCode = 0;
            $sErrorMessage = '';
        }
        catch (\Zend\Db\Adapter\Exception\InvalidQueryException $e){
            $aResultSet = null;
            $bSuccess = false;
            $nErrorCode = $e->getPrevious()->getCode();
            $sErrorMessage = $e->getPrevious()->getMessage();
        }
        
        switch($nQuery){
            case self::QUERY_SELECT:
                $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->select()->where($aWhere));
            break;
            case self::QUERY_INSERT:
                $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->insert()->values($aSet));
            break;
            case self::QUERY_UPDATE:
                $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->update()->set($aSet)->where($aWhere));
            break;
            case self::QUERY_DELETE:
                $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->delete()->where($aWhere));
            break;
        }
        
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
    }

    public function select($where = null) {
        return $this->_query(self::QUERY_SELECT, null, $where);
    }
    
    public function insert($set) {
        return $this->_query(self::QUERY_INSERT, $set, null);
    }
    
    public function update($set, $where = null) {
        return $this->_query(self::QUERY_UPDATE, $set, $where);
    }
    
    public function delete($where) {
        return $this->_query(self::QUERY_DELETE, null, $where);
    }
    
    public function beginTransaction(){
        $this->getAdapter()->getDriver()->getConnection()->beginTransaction();
    }
    
    public function rollback() {
        $this->getAdapter()->getDriver()->getConnection()->rollback();
    }
    
    public function commit(){
        $this->getAdapter()->getDriver()->getConnection()->commit();
    }
}
