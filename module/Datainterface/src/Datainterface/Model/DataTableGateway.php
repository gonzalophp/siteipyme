<?php
namespace Datainterface\Model;

class DataTableGateway extends \Zend\Db\TableGateway\AbstractTableGateway {

    public function __construct($adapter, $table, $row){
        $this->table = $table;
        $this->adapter = $adapter;
        $this->resultSetPrototype = new \Zend\Db\ResultSet\ResultSet(); 
        $this->resultSetPrototype->setArrayObjectPrototype($row); 
    }

    public function select($where = null) {
        try {
            $aResultSet = parent::select($where);
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
        error_reporting (0);
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->select()->where($where));
        error_reporting (E_ALL);
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
    }
    
    public function insert($set) {
        try {
            $aResultSet = parent::insert($set);
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
        error_reporting (0);
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->insert()->values($set));
        error_reporting (E_ALL);
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
    }
    
    public function update($set, $where = null) {
        try {
            $aResultSet = parent::update($set, $where);
            $bSuccess = true;
            $nErrorCode = 0;
            $sErrorMessage = '';
        }
        catch (\Zend\Db\Adapter\Exception\InvalidQueryException $e){
            $aResultSet = NULL;
            $bSuccess = TRUE;
            $nErrorCode = $e->getPrevious()->getCode();
            $sErrorMessage = $e->getPrevious()->getMessage();
        }
        
        error_reporting (0);
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->update()->set($set)->where($where));
        error_reporting (E_ALL);
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
    }
    
    public function delete($where) {
        try {
            $aResultSet = parent::delete($where);
            $bSuccess = true;
            $nErrorCode = 0;
            $sErrorMessage = '';
        }
        catch (\Zend\Db\Adapter\Exception\InvalidQueryException $e){
            $aResultSet = NULL;
            $bSuccess = TRUE;
            $nErrorCode = $e->getPrevious()->getCode();
            $sErrorMessage = $e->getPrevious()->getMessage();
        }
        error_reporting (0);
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->delete()->where($where));
        error_reporting (E_ALL);
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
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
