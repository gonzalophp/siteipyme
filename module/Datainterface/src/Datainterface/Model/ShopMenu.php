<?php
namespace Datainterface\Model;

class ShopMenu {
    
    public function getMenu($aOptions){
        if (array_key_exists('username', $aOptions)){
            $oUserMenu = array('label' => $aOptions['username']
                                , 'url' => '#/user/account/'.$aOptions['username']
                                , 'nodes' => array());
        }
        else {
            $oUserMenu = array('label' => 'Sign In'
                                , 'url' => '#/user/signin'
                                , 'nodes' => array());
        }
        $aMenuList = array();
        array_push($aMenuList,
                    array('label' => 'iPyME'
                        , 'url' => ''
                        , 'nodes' => array())
                    , $oUserMenu);
        
        if (array_key_exists('username', $aOptions)){
            array_push($aMenuList
                 ,array('label' => 'logout'
                      , 'url' => '#/user/logout'
                      , 'nodes' => array()));
        }
        
        array_push($aMenuList
                 ,array('label' => 'Basket'
                      , 'url' => '#/basket'
                      , 'nodes' => array()));
        return $aMenuList;
    }
}
?>