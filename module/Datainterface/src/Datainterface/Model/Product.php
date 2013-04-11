<?php
namespace Datainterface\Model;

class Product {
    
    public $p_id; 
    public $p_ref;
    public $p_description;
    public $p_long_description;
    public $p_weight;
    public $p_size;
            
    public function exchangeArray($data) {
        $this->p_id             = (isset($data['p_id'])) ? $data['p_id'] : null;
        $this->p_ref            = (isset($data['p_ref'])) ? $data['p_ref'] : null;
        $this->p_description    = (isset($data['p_description'])) ? $data['p_description'] : null;
        $this->p_long_description = (isset($data['p_long_description'])) ? $data['p_long_description'] : null;
        $this->p_weight         = (isset($data['p_weight'])) ? $data['p_weight'] : null;
        $this->p_size           = (isset($data['p_size'])) ? $data['p_size'] : null;
    }
    
    public function getArrayCopy(){
        return get_object_vars($this);
    }
}