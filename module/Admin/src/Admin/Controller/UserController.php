<?php
namespace Admin\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Zend\Json\Json;

class UserController extends AbstractActionController {
    function indexAction() {
        parent::indexAction();
        $oViewModel = new ViewModel();
        $oViewModel->setTerminal(true);
        $oViewModel->setTemplate('xhr/xhr');
        
        $aMenuList = array(
            (object) array(
                'label' => 'iPyME'
                ,'url' => 'http://www.elmundo.es'
                ,'nodes' => array(
                    (object) array(
                        'label' => 'Home A'
                        ,'url' => 'http://www.elmundo.es'
                       ,'nodes' => array())
                   ,(object) array(
                       'label' => 'Home B'
                       ,'url' => 'http://www.elmundo.es'
                      ,'nodes' => array(
                            (object) array(
                                'label' => 'Home B A'
                                ,'url' => 'http://www.elmundo.es'
                              , 'nodes' => array())
                          , (object) array(
                              'label' => 'Home B B'
                              ,'url' => 'http://www.elmundo.es'
                              , 'nodes' => array())))
                    ,(object) array(
                        'label' => 'Product'
                        ,'url' => '#/admin/product'
                       ,'nodes' => array())
                    ,(object) array(
                        'label' => 'view 1'
                        ,'url' => '#/view1'
                       ,'nodes' => array())))
            , (object) array(
                'label' => 'Forms'
                ,'url' => 'http://www.elmundo.es'
               ,'nodes' => array())
            , (object) array(
                'label' => 'Resources'
                ,'url' => 'http://www.elmundo.es'
               ,'nodes' => array(
                    (object) array(
                        'label' => 'Resources A'
                        ,'url' => 'http://www.elmundo.es'
                       ,'nodes' => array())
                    , (object) array(
                        'label' => 'Resources B'
                        ,'url' => 'http://www.elmundo.es'
                       ,'nodes' => array()))));

        $oViewModel->setVariable('XHR_Response', Json::encode($aMenuList));
        return ($oViewModel);
    }
    
    function pruebaAction() {
        echo "this is prueba";exit;
    }
}
?>
