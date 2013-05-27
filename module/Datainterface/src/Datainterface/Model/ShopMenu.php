<?php
namespace Datainterface\Model;

class ShopMenu {
    
    public function getMenu($aOptions){
        
        $oUserMenu = (object) (array_key_exists('username', $aOptions)) ? 
             array(
                'label' => $aOptions['username']
                , 'url' => '#/user/account/'.$aOptions['username']
                , 'nodes' => array())
            :array(
                'label' => 'Sign In'
                , 'url' => '#/user/signin'
                , 'nodes' => array());
                
                
        $aMenuList = array(
            (object) array(
                'label' => 'iPyME'
                , 'url' => ''
                , 'nodes' => array())
            , $oUserMenu
            , (object) array(
                'label' => 'Basket'
                , 'url' => '#/basket'
                , 'nodes' => array()));
        return $aMenuList;
    }
}
?>