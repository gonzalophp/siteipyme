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
        $oViewModel->setVariable('XHR_Response', Json::encode((object) array('name'=>'Gonzalo', 'surname' => 'Grado')));
        return ($oViewModel);
    }
    
    function pruebaAction() {
        echo "this is prueba";exit;
    }
}
?>
