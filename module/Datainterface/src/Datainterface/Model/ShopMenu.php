<?php
namespace Datainterface\Model;

class ShopMenu {
    
    public function getMenu($aOptions){
        $aMenuList = array('label' => 'iPyME'
                        , 'url' => ''
                        , 'nodes' => array());
        
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
        
        array_push($aMenuList,
                    array('label' => 'iPyME'
                        , 'url' => ''
                        , 'nodes' => array())
                    , $oUserMenu);
        
        array_push($aMenuList
                 ,array('label' => '-admin panel-'
                      , 'url' => '#/admin'
                      , 'nodes' => array()));
        
        if (array_key_exists('username', $aOptions)){
            array_push($aMenuList
                 ,array('label' => 'logout'
                      , 'url' => '#/user/logout'
                      , 'nodes' => array()));
        }
        
        return $aMenuList;
    }
}
?>