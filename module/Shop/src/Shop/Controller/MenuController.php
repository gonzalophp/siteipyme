<?php
namespace Shop\Controller;

class MenuController extends \Zend\Mvc\Controller\AbstractActionController {
    public function mainAction() {
        $oUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->getMenu(array('username' => $oUser->u_name));
        return new \Zend\View\Model\JsonModel($aMenuList);
    }
    
    public function shopAction() {
        $oUser = $this->getServiceLocator()->get('User\Model\UserCredentials')->getUserDetails();
        $oMenuList = new \Datainterface\Model\ShopMenu;
        
        $aMenuList= $oMenuList->getMenu(is_null($oUser)?array():array('username' => $oUser['u_name']));
        return new \Zend\View\Model\JsonModel($aMenuList);
    }
    
    public function providerAction() {
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
    
    public function customerAction(){
        $oMenuList = new \Datainterface\Model\MainMenu;
        
        $aResponse = array('menuitems' => array(array('form'        => 'admin.customer'
                                                     ,'displayName' => 'New'
                                                     ,'start_empty' => 1
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.customer'
                                                     ,'displayName' => 'Edit'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.customer'
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
    
    public function productAction() {

        $aResponse = array('menuitems' => array(array('form'        => 'admin.product'
                                                     ,'displayName' => 'New'
                                                     ,'start_empty' => 1
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.product'
                                                     ,'displayName' => 'Edit'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.product'
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
    
    public function userAction(){
        $oMenuList = new \Datainterface\Model\MainMenu;
        
        $aResponse = array('menuitems' => array(array('form'        => 'admin.user'
                                                     ,'displayName' => 'New'
                                                     ,'start_empty' => 1
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.user'
                                                     ,'displayName' => 'Edit'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.user'
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
    
    public function categoryAction(){
        $oMenuList = new \Datainterface\Model\MainMenu;
        $aMenuList= $oMenuList->aMenuList;
        
        $aResponse = array('menuitems' => array(array('form'        => 'admin.user'
                                                     ,'displayName' => 'New'
                                                     ,'start_empty' => 1
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.user'
                                                     ,'displayName' => 'Edit'
                                                     ,'start_empty' => 0
                                                     ,'readonly'    => 0
                                                     ,'buttons'     => array(array('action' => 'save'
                                                                                 , 'displayName' => 'Save'
                                                                                 , 'class' => 'btn-primary')
                                                                            ,array('action' => 'cancel'
                                                                                 , 'displayName' => 'Cancel'
                                                                                 , 'class' => 'btn-default')))
                                               ,array('form'        => 'admin.user'
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
