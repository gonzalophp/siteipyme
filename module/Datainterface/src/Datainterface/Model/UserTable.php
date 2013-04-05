<?php

namespace Datainterface\Model;

class UserTable extends \Zend\Db\TableGateway\AbstractTableGateway {
    public $oUser;

    public function __construct($adapter, $table){
        $this->table = $table;
        $this->adapter = $adapter;
        $this->resultSetPrototype = new \Zend\Db\ResultSet\ResultSet(); 
        $this->resultSetPrototype->setArrayObjectPrototype(new \Datainterface\Model\User()); 
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
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->select()->where($where));
        
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
        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->insert()->values($set));
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
        
//        var_dump($this->getAdapter()->getDriver());
//        var_dump($this->getSql()->getSqlStringForSqlObject($this->getSql()->update()->set($set)->where($where)));
//        exit;
//        $sSQL = $this->getSql()->getSqlStringForSqlObject($this->getSql()->update()->set($set)->where($where));
        $sSQL='';
        return array( 'resultset'       => $aResultSet
                    , 'success'         => $bSuccess
                    , 'error_code'      => $nErrorCode
                    , 'error_message'   => $sErrorMessage
                    , 'sql'             => $sSQL);
    }
    

    public function getUser($id){
        $id  = (int) $id;
        $rowset = $this->tableGateway->select(array('id' => $id));
        $row = $rowset->current();
        if (!$row) {
            throw new \Exception("Could not find row $id");
        }
        return $row;
    }

    public function saveUser(User $user)
    {
        $data = array(
            'artist' => $user->artist,
            'title'  => $user->title,
        );

        $id = (int)$user->id;
        if ($id == 0) {
            $this->tableGateway->insert($data);
        } else {
            if ($this->getUser($id)) {
                $this->tableGateway->update($data, array('id' => $id));
            } else {
                throw new \Exception('Form id does not exist');
            }
        }
    }

    public function deleteUser($id)
    {
        $this->tableGateway->delete(array('id' => $id));
    }
}
