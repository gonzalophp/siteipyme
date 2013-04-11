<?php

namespace Datainterface\Model;

class ProductTable extends \Zend\Db\TableGateway\AbstractTableGateway {
    public $oProduct;

    public function __construct($adapter, $table){
        $this->table = $table;
        $this->adapter = $adapter;
        $this->resultSetPrototype = new \Zend\Db\ResultSet\ResultSet(); 
        $this->resultSetPrototype->setArrayObjectPrototype(new \Datainterface\Model\Product()); 
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
    

    public function getProduct($id){
        $id  = (int) $id;
        $rowset = $this->tableGateway->select(array('id' => $id));
        $row = $rowset->current();
        if (!$row) {
            throw new \Exception("Could not find row $id");
        }
        return $row;
    }

    public function saveProduct(Product $product)
    {
        $data = array(
            'artist' => $product->artist,
            'title'  => $product->title,
        );

        $id = (int)$product->id;
        if ($id == 0) {
            $this->tableGateway->insert($data);
        } else {
            if ($this->getProduct($id)) {
                $this->tableGateway->update($data, array('id' => $id));
            } else {
                throw new \Exception('Form id does not exist');
            }
        }
    }

    public function deleteProduct($id)
    {
        $this->tableGateway->delete(array('id' => $id));
    }
}
