<?php
namespace Datainterface\Model;

class User {
    
    public $u_id; 
    public $u_session;
    public $u_last_login;
    public $u_email;
    public $u_status;
    public $u_basket;
    public $u_customer;
    public $u_name;
    public $u_password_hash;

    public function exchangeArray($data) {
        $this->u_id             = (isset($data['u_id'])) ? $data['u_id'] : null;
        $this->u_session        = (isset($data['u_session'])) ? $data['u_session'] : null;
        $this->u_last_login     = (isset($data['u_last_login'])) ? $data['u_last_login'] : null;
        $this->u_email          = (isset($data['u_email'])) ? $data['u_email'] : null;
        $this->u_status         = (isset($data['u_status'])) ? $data['u_status'] : null;
        $this->u_basket         = (isset($data['u_basket'])) ? $data['u_basket'] : null;
        $this->u_customer       = (isset($data['u_customer'])) ? $data['u_customer'] : null;
        $this->u_name           = (isset($data['u_name'])) ? $data['u_name'] : null;
        $this->u_password_hash  = (isset($data['u_password_hash'])) ? $data['u_password_hash'] : null;
    }
    
    public function getArrayCopy(){
        return get_object_vars($this);
    }
}