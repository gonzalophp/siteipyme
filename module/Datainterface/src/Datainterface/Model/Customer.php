<?php
namespace Datainterface\Model;

class Product {
    
    public $c_id; 
    public $c_legal_entity;
            
    public function exchangeArray($data) {
        $this->c_id             = (isset($data['c_id'])) ? $data['c_id'] : null;
        $this->c_legal_entity   = (isset($data['c_legal_entity'])) ? $data['c_legal_entity'] : null;
    }
    
    public function getArrayCopy(){
        return get_object_vars($this);
    }
}