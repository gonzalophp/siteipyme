<?php
namespace Menus\Controller;

use Zend\Mvc\Controller\AbstractActionController;

class ProviderController extends AbstractActionController {
    
    function indexAction() {
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        
        $aResponse = array('menuitems' => array(array('form'        => 'admin.provider'
                                                     ,'displayName' => 'New'
                                                     ,'start_empty' => 1
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.provider'
                                                     ,'displayName' => 'Edit'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.provider'
                                                     ,'displayName' => 'Delete'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 1
                                                     ,'buttons'     => array(array('action' => 'delete'
                                                                                 , 'displayName' => 'Delete'
                                                                                 , 'class' => 'btn-danger')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))));
        
        return new \Zend\View\Model\JsonModel($aResponse);
    }
}
?>